import re
from dataclasses import dataclass

from src.errors import TargetCodeError
from src.ir import IRFunction, IRProgram, Quad


_INTEGER = re.compile(r"-?\d+\Z")
_LABEL = re.compile(r"L\d+\Z")
_ARRAY_LENGTH = re.compile(r"\[[^;]+;(\d+)\]\Z")
_TEMP_ARRAY_LENGTH = re.compile(r"\[_;(\d+)\]\Z")
_TEMP_TUPLE_LENGTH = re.compile(r"\(_;(\d+)\)\Z")


@dataclass
class FrameLayout:
    offsets: dict[str, int]
    backing_offsets: dict[str, int]
    lengths: dict[str, int]
    frame_size: int


class AssemblyGenerator:
    """把四元式降低为可由 GCC/Clang 汇编的 x86-64 Windows 汇编。"""

    PARAM_REGISTERS = ("rcx", "rdx", "r8", "r9")
    BINARY_INSTRUCTIONS = {"+": "add", "-": "sub", "*": "imul"}
    SET_INSTRUCTIONS = {
        "<": "setl",
        "<=": "setle",
        ">": "setg",
        ">=": "setge",
        "==": "sete",
        "!=": "setne",
    }

    def generate(self, program: IRProgram) -> str:
        lines = [".intel_syntax noprefix", ".text"]
        for function in program.functions:
            lines.extend(self._generate_function(function))
        return "\n".join(lines) + "\n"

    def _generate_function(self, function: IRFunction) -> list[str]:
        layout = self._build_layout(function)
        prefix = f".{function.name}_"
        end_label = f"{prefix}return"
        bounds_label = f"{prefix}bounds_error"
        lines = [
            "",
            f".globl {function.name}",
            f"{function.name}:",
            "    push rbp",
            "    mov rbp, rsp",
            f"    sub rsp, {layout.frame_size}",
        ]

        for index, param in enumerate(function.params):
            if index < len(self.PARAM_REGISTERS):
                lines.append(f"    mov QWORD PTR [rbp-{layout.offsets[param]}], {self.PARAM_REGISTERS[index]}")
            else:
                incoming = 48 + (index - len(self.PARAM_REGISTERS)) * 8
                lines.extend([
                    f"    mov rax, QWORD PTR [rbp+{incoming}]",
                    f"    mov QWORD PTR [rbp-{layout.offsets[param]}], rax",
                ])

        pending_args: list[str] = []
        for quad in function.quads:
            if quad.op == "param":
                pending_args.append(self._required(quad.result, "param 缺少实参"))
                continue
            lines.extend(
                self._generate_quad(quad, layout, prefix, end_label, bounds_label, pending_args)
            )
            if quad.op == "call":
                pending_args.clear()

        if pending_args:
            raise TargetCodeError(f"函数 {function.name} 存在未消费的 param 四元式")

        lines.extend([
            "    xor eax, eax",
            f"{end_label}:",
            "    mov rsp, rbp",
            "    pop rbp",
            "    ret",
            f"{bounds_label}:",
            "    ud2",
        ])
        return lines

    def _generate_quad(
        self,
        quad: Quad,
        layout: FrameLayout,
        prefix: str,
        end_label: str,
        bounds_label: str,
        pending_args: list[str],
    ) -> list[str]:
        op = quad.op
        if op == "decl":
            if quad.result in layout.backing_offsets:
                return [
                    f"    lea rax, [rbp-{layout.backing_offsets[quad.result]}]",
                    *self._store(quad.result, "rax", layout),
                ]
            return []
        if op == "=":
            return [*self._load(quad.arg1, "rax", layout), *self._store(quad.result, "rax", layout)]
        if op in self.BINARY_INSTRUCTIONS:
            return [
                *self._load(quad.arg1, "rax", layout),
                *self._load(quad.arg2, "rcx", layout),
                f"    {self.BINARY_INSTRUCTIONS[op]} rax, rcx",
                *self._store(quad.result, "rax", layout),
            ]
        if op == "/":
            return [
                *self._load(quad.arg1, "rax", layout),
                "    cqo",
                *self._load(quad.arg2, "rcx", layout),
                "    idiv rcx",
                *self._store(quad.result, "rax", layout),
            ]
        if op in self.SET_INSTRUCTIONS:
            return [
                *self._load(quad.arg1, "rax", layout),
                *self._load(quad.arg2, "rcx", layout),
                "    cmp rax, rcx",
                f"    {self.SET_INSTRUCTIONS[op]} al",
                "    movzx rax, al",
                *self._store(quad.result, "rax", layout),
            ]
        if op == "label":
            return [f"{prefix}{self._required(quad.result, 'label 缺少名称')}:"]
        if op == "j":
            return [f"    jmp {prefix}{self._required(quad.result, 'j 缺少目标')}"]
        if op == "jz":
            return [
                *self._load(quad.arg1, "rax", layout),
                "    test rax, rax",
                f"    je {prefix}{self._required(quad.result, 'jz 缺少目标')}",
            ]
        if op == "return":
            return [*self._load(quad.arg1, "rax", layout), f"    jmp {end_label}"]
        if op == "call":
            return self._generate_call(quad, pending_args, layout)
        if op in {"ref", "ref_mut"}:
            source = self._required(quad.arg1, "引用缺少源左值")
            if source not in layout.offsets:
                raise TargetCodeError(f"不能取得常量 {source!r} 的地址")
            return [
                f"    lea rax, [rbp-{layout.offsets[source]}]",
                *self._store(quad.result, "rax", layout),
            ]
        if op == "deref":
            return [
                *self._load(quad.arg1, "rax", layout),
                "    mov rax, QWORD PTR [rax]",
                *self._store(quad.result, "rax", layout),
            ]
        if op == "*=":
            return [
                *self._load(quad.result, "rax", layout),
                *self._load(quad.arg1, "rcx", layout),
                "    mov QWORD PTR [rax], rcx",
            ]
        if op == "[]":
            source = self._required(quad.arg1, "数组读取缺少数组")
            check = self._bounds_check(source, "rcx", layout, bounds_label)
            return [
                *self._load(quad.arg1, "rax", layout),
                *self._load(quad.arg2, "rcx", layout),
                *check,
                "    mov rax, QWORD PTR [rax+rcx*8]",
                *self._store(quad.result, "rax", layout),
            ]
        if op == "[]=":
            target = self._required(quad.result, "数组写入缺少数组")
            check = self._bounds_check(target, "rcx", layout, bounds_label)
            return [
                *self._load(quad.result, "rax", layout),
                *self._load(quad.arg2, "rcx", layout),
                *check,
                *self._load(quad.arg1, "rdx", layout),
                "    mov QWORD PTR [rax+rcx*8], rdx",
            ]
        if op == ".":
            return [
                *self._load(quad.arg1, "rax", layout),
                *self._load(quad.arg2, "rcx", layout),
                "    mov rax, QWORD PTR [rax+rcx*8]",
                *self._store(quad.result, "rax", layout),
            ]
        if op == ".=":
            return [
                *self._load(quad.result, "rax", layout),
                *self._load(quad.arg2, "rcx", layout),
                *self._load(quad.arg1, "rdx", layout),
                "    mov QWORD PTR [rax+rcx*8], rdx",
            ]
        if op == "len":
            source = self._required(quad.arg1, "len 缺少数组")
            if source not in layout.lengths:
                raise TargetCodeError(f"无法静态确定数组 {source} 的长度")
            return [
                f"    mov rax, {layout.lengths[source]}",
                *self._store(quad.result, "rax", layout),
            ]
        raise TargetCodeError(f"暂不支持的四元式操作: {op}")

    def _generate_call(self, quad: Quad, args: list[str], layout: FrameLayout) -> list[str]:
        expected = int(self._required(quad.arg2, "call 缺少实参数量"))
        if expected != len(args):
            raise TargetCodeError(f"call 声明 {expected} 个实参，实际收集到 {len(args)} 个")

        extra = max(0, len(args) - len(self.PARAM_REGISTERS))
        call_space = self._align16(32 + extra * 8)
        lines = [f"    sub rsp, {call_space}"]
        for index, arg in enumerate(args):
            if index < len(self.PARAM_REGISTERS):
                lines.extend(self._load(arg, self.PARAM_REGISTERS[index], layout))
            else:
                lines.extend(self._load(arg, "rax", layout))
                lines.append(f"    mov QWORD PTR [rsp+{32 + (index - 4) * 8}], rax")
        lines.extend([
            f"    call {self._required(quad.arg1, 'call 缺少函数名')}",
            f"    add rsp, {call_space}",
            *self._store(quad.result, "rax", layout),
        ])
        return lines

    def _build_layout(self, function: IRFunction) -> FrameLayout:
        names: list[str] = []
        for param in function.params:
            self._append_name(names, param)

        backing_lengths: dict[str, int] = {}
        lengths: dict[str, int] = {}
        for quad in function.quads:
            fields = self._place_fields(quad)
            for field in fields:
                self._append_name(names, field)
            if quad.op == "decl" and quad.result is not None and quad.arg1 is not None:
                temp_match = _TEMP_ARRAY_LENGTH.fullmatch(quad.arg1) or _TEMP_TUPLE_LENGTH.fullmatch(quad.arg1)
                array_match = _ARRAY_LENGTH.fullmatch(quad.arg1)
                if temp_match:
                    backing_lengths[quad.result] = int(temp_match.group(1))
                if array_match:
                    lengths[quad.result] = int(array_match.group(1))

        lengths.update(backing_lengths)
        changed = True
        while changed:
            changed = False
            for quad in function.quads:
                if quad.op == "=" and quad.arg1 in lengths and quad.result not in lengths:
                    lengths[quad.result] = lengths[quad.arg1]
                    changed = True

        offsets: dict[str, int] = {}
        offset = 0
        for name in names:
            offset += 8
            offsets[name] = offset

        backing_offsets: dict[str, int] = {}
        for name, length in backing_lengths.items():
            offset += max(1, length) * 8
            backing_offsets[name] = offset

        return FrameLayout(
            offsets=offsets,
            backing_offsets=backing_offsets,
            lengths=lengths,
            frame_size=max(16, self._align16(offset)),
        )

    def _place_fields(self, quad: Quad) -> list[str]:
        if quad.op == "decl":
            return [quad.result] if quad.result else []
        if quad.op in {"label", "j"}:
            return []
        if quad.op == "jz":
            return [quad.arg1] if quad.arg1 else []
        if quad.op == "call":
            return [quad.result] if quad.result else []
        return [value for value in (quad.arg1, quad.arg2, quad.result) if value is not None]

    def _append_name(self, names: list[str], value: str) -> None:
        if value in {"_", "()"} or _INTEGER.fullmatch(value) or _LABEL.fullmatch(value):
            return
        if value not in names:
            names.append(value)

    def _load(self, value: str | None, register: str, layout: FrameLayout) -> list[str]:
        if value is None or value in {"_", "()"}:
            return [f"    xor {register}, {register}"]
        if _INTEGER.fullmatch(value):
            return [f"    mov {register}, {value}"]
        if value not in layout.offsets:
            raise TargetCodeError(f"未知的值位置: {value}")
        return [f"    mov {register}, QWORD PTR [rbp-{layout.offsets[value]}]"]

    def _bounds_check(
        self,
        collection: str,
        index_register: str,
        layout: FrameLayout,
        bounds_label: str,
    ) -> list[str]:
        length = layout.lengths.get(collection)
        if length is None:
            return []
        return [
            f"    cmp {index_register}, 0",
            f"    jl {bounds_label}",
            f"    cmp {index_register}, {length}",
            f"    jge {bounds_label}",
        ]

    def _store(self, value: str | None, register: str, layout: FrameLayout) -> list[str]:
        name = self._required(value, "四元式缺少结果位置")
        if name not in layout.offsets:
            raise TargetCodeError(f"未知的结果位置: {name}")
        return [f"    mov QWORD PTR [rbp-{layout.offsets[name]}], {register}"]

    @staticmethod
    def _required(value: str | None, message: str) -> str:
        if value is None:
            raise TargetCodeError(message)
        return value

    @staticmethod
    def _align16(value: int) -> int:
        return (value + 15) // 16 * 16
