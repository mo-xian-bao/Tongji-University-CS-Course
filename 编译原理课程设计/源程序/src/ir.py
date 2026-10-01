from dataclasses import dataclass
from typing import Optional


EMPTY = "_"


@dataclass
class Quad:
    op: str
    arg1: Optional[str]
    arg2: Optional[str]
    result: Optional[str]

    def format(self) -> str:
        return f"({self.op}, {_fmt(self.arg1)}, {_fmt(self.arg2)}, {_fmt(self.result)})"


@dataclass
class IRFunction:
    name: str
    params: list[str]
    quads: list[Quad]

    def format(self) -> str:
        param_text = ", ".join(self.params)
        lines = [f"Function {self.name}({param_text}):"]
        if not self.quads:
            lines.append("  <empty>")
            return "\n".join(lines)

        for index, quad in enumerate(self.quads):
            lines.append(f"  {index}: {quad.format()}")
        return "\n".join(lines)


@dataclass
class IRProgram:
    functions: list[IRFunction]

    def format(self) -> str:
        return "\n\n".join(function.format() for function in self.functions)


class IRBuilder:
    def __init__(self):
        self.quads: list[Quad] = []
        self.temp_id = 0
        self.label_id = 0

    def new_temp(self) -> str:
        self.temp_id += 1
        return f"t{self.temp_id}"

    def new_label(self) -> str:
        self.label_id += 1
        return f"L{self.label_id}"

    def emit_label(self, label: str) -> None:
        self.emit("label", result=label)

    def emit(
        self,
        op: str,
        arg1: Optional[str] = None,
        arg2: Optional[str] = None,
        result: Optional[str] = None,
    ) -> Quad:
        quad = Quad(op=op, arg1=arg1, arg2=arg2, result=result)
        self.quads.append(quad)
        return quad


def _fmt(value: Optional[str]) -> str:
    return EMPTY if value is None else value
