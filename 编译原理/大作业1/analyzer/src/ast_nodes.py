from dataclasses import dataclass
from typing import Optional


# ---------- 抽象语法树（AST）节点 ----------

@dataclass
class Program:
    declarations: list["FunctionDecl"]


@dataclass
class FunctionDecl:
    name: str
    params: list["Param"]
    return_type: Optional["TypeNode"]
    body: "Block"


@dataclass
class Param:
    is_mut: bool
    name: str
    type_name: "TypeNode"


class TypeNode:
    pass


@dataclass
class I32Type(TypeNode):
    pass


@dataclass
class RefType(TypeNode):
    is_mut: bool
    inner: TypeNode


@dataclass
class ArrayType(TypeNode):
    element_type: TypeNode
    size: int


@dataclass
class TupleType(TypeNode):
    elements: list[TypeNode]


@dataclass
class Block:
    statements: list["Statement"]
    result: Optional["Expr"] = None


class Statement:
    pass


@dataclass
class EmptyStmt(Statement):
    pass


@dataclass
class LetStmt(Statement):
    is_mut: bool
    name: str
    type_name: Optional[TypeNode]
    initializer: Optional["Expr"] = None


@dataclass
class AssignStmt(Statement):
    target: "Expr"
    value: "Expr"


@dataclass
class ReturnStmt(Statement):
    value: Optional["Expr"]


@dataclass
class ElseIf:
    condition: "Expr"
    block: Block


@dataclass
class IfStmt(Statement):
    condition: "Expr"
    then_block: Block
    else_if_blocks: list[ElseIf]
    else_block: Optional[Block]


@dataclass
class WhileStmt(Statement):
    condition: "Expr"
    body: Block


@dataclass
class LoopStmt(Statement):
    body: Block


@dataclass
class ForStmt(Statement):
    is_mut: bool
    name: str
    type_name: Optional[TypeNode]
    iterable: "Expr"
    body: Block


@dataclass
class BreakStmt(Statement):
    value: Optional["Expr"] = None


@dataclass
class ContinueStmt(Statement):
    pass


@dataclass
class ExprStmt(Statement):
    expr: "Expr"


class Expr:
    pass


@dataclass
class NumberExpr(Expr):
    value: int


@dataclass
class BlockExpr(Expr):
    block: Block


@dataclass
class IfExpr(Expr):
    condition: Expr
    then_block: Block
    else_if_blocks: list[ElseIf]
    else_block: Block


@dataclass
class LoopExpr(Expr):
    body: Block


@dataclass
class IdentifierExpr(Expr):
    name: str


@dataclass
class CallExpr(Expr):
    callee: str
    arguments: list[Expr]


@dataclass
class BorrowExpr(Expr):
    is_mut: bool
    value: Expr


@dataclass
class DerefExpr(Expr):
    value: Expr


@dataclass
class ArrayExpr(Expr):
    elements: list[Expr]


@dataclass
class TupleExpr(Expr):
    elements: list[Expr]


@dataclass
class IndexExpr(Expr):
    collection: Expr
    index: Expr


@dataclass
class FieldExpr(Expr):
    target: Expr
    field: int


@dataclass
class RangeExpr(Expr):
    start: Expr
    end: Expr


@dataclass
class BinaryExpr(Expr):
    left: Expr
    op: str
    right: Expr


# ---------- AST 转字典，便于打印查看 ----------

def type_to_dict(node):
    if node is None:
        return None

    if isinstance(node, I32Type):
        return {"type": "I32Type"}

    if isinstance(node, RefType):
        return {
            "type": "RefType",
            "is_mut": node.is_mut,
            "inner": type_to_dict(node.inner),
        }

    if isinstance(node, ArrayType):
        return {
            "type": "ArrayType",
            "element_type": type_to_dict(node.element_type),
            "size": node.size,
        }

    if isinstance(node, TupleType):
        return {
            "type": "TupleType",
            "elements": [type_to_dict(element) for element in node.elements],
        }

    raise TypeError(f"不支持的类型节点: {type(node)!r}")

def ast_to_dict(node):
    if isinstance(node, Program):
        return {
            "type": "Program",
            "declarations": [ast_to_dict(d) for d in node.declarations],
        }

    if isinstance(node, FunctionDecl):
        return {
            "type": "FunctionDecl",
            "name": node.name,
            "params": [ast_to_dict(p) for p in node.params],
            "return_type": type_to_dict(node.return_type),
            "body": ast_to_dict(node.body),
        }

    if isinstance(node, Param):
        return {
            "type": "Param",
            "is_mut": node.is_mut,
            "name": node.name,
            "type_name": type_to_dict(node.type_name),
        }

    if isinstance(node, Block):
        return {
            "type": "Block",
            "statements": [ast_to_dict(s) for s in node.statements],
            "result": ast_to_dict(node.result) if node.result is not None else None,
        }

    if isinstance(node, EmptyStmt):
        return {"type": "EmptyStmt"}

    if isinstance(node, LetStmt):
        return {
            "type": "LetStmt",
            "is_mut": node.is_mut,
            "name": node.name,
            "type_name": type_to_dict(node.type_name),
            "initializer": ast_to_dict(node.initializer) if node.initializer is not None else None,
        }

    if isinstance(node, AssignStmt):
        return {
            "type": "AssignStmt",
            "target": ast_to_dict(node.target),
            "value": ast_to_dict(node.value),
        }

    if isinstance(node, ReturnStmt):
        return {
            "type": "ReturnStmt",
            "value": ast_to_dict(node.value) if node.value is not None else None,
        }

    if isinstance(node, IfStmt):
        return {
            "type": "IfStmt",
            "condition": ast_to_dict(node.condition),
            "then_block": ast_to_dict(node.then_block),
            "else_if_blocks": [ast_to_dict(else_if) for else_if in node.else_if_blocks],
            "else_block": ast_to_dict(node.else_block) if node.else_block is not None else None,
        }

    if isinstance(node, ElseIf):
        return {
            "type": "ElseIf",
            "condition": ast_to_dict(node.condition),
            "block": ast_to_dict(node.block),
        }

    if isinstance(node, WhileStmt):
        return {
            "type": "WhileStmt",
            "condition": ast_to_dict(node.condition),
            "body": ast_to_dict(node.body),
        }

    if isinstance(node, LoopStmt):
        return {
            "type": "LoopStmt",
            "body": ast_to_dict(node.body),
        }

    if isinstance(node, ForStmt):
        return {
            "type": "ForStmt",
            "is_mut": node.is_mut,
            "name": node.name,
            "type_name": type_to_dict(node.type_name),
            "iterable": ast_to_dict(node.iterable),
            "body": ast_to_dict(node.body),
        }

    if isinstance(node, BreakStmt):
        return {
            "type": "BreakStmt",
            "value": ast_to_dict(node.value) if node.value is not None else None,
        }

    if isinstance(node, ContinueStmt):
        return {"type": "ContinueStmt"}

    if isinstance(node, ExprStmt):
        return {
            "type": "ExprStmt",
            "expr": ast_to_dict(node.expr),
        }

    if isinstance(node, NumberExpr):
        return {
            "type": "NumberExpr",
            "value": node.value,
        }

    if isinstance(node, BlockExpr):
        return {
            "type": "BlockExpr",
            "block": ast_to_dict(node.block),
        }

    if isinstance(node, IfExpr):
        return {
            "type": "IfExpr",
            "condition": ast_to_dict(node.condition),
            "then_block": ast_to_dict(node.then_block),
            "else_if_blocks": [ast_to_dict(else_if) for else_if in node.else_if_blocks],
            "else_block": ast_to_dict(node.else_block),
        }

    if isinstance(node, LoopExpr):
        return {
            "type": "LoopExpr",
            "body": ast_to_dict(node.body),
        }

    if isinstance(node, IdentifierExpr):
        return {
            "type": "IdentifierExpr",
            "name": node.name,
        }

    if isinstance(node, CallExpr):
        return {
            "type": "CallExpr",
            "callee": node.callee,
            "arguments": [ast_to_dict(arg) for arg in node.arguments],
        }

    if isinstance(node, BorrowExpr):
        return {
            "type": "BorrowExpr",
            "is_mut": node.is_mut,
            "value": ast_to_dict(node.value),
        }

    if isinstance(node, DerefExpr):
        return {
            "type": "DerefExpr",
            "value": ast_to_dict(node.value),
        }

    if isinstance(node, ArrayExpr):
        return {
            "type": "ArrayExpr",
            "elements": [ast_to_dict(element) for element in node.elements],
        }

    if isinstance(node, TupleExpr):
        return {
            "type": "TupleExpr",
            "elements": [ast_to_dict(element) for element in node.elements],
        }

    if isinstance(node, IndexExpr):
        return {
            "type": "IndexExpr",
            "collection": ast_to_dict(node.collection),
            "index": ast_to_dict(node.index),
        }

    if isinstance(node, FieldExpr):
        return {
            "type": "FieldExpr",
            "target": ast_to_dict(node.target),
            "field": node.field,
        }

    if isinstance(node, RangeExpr):
        return {
            "type": "RangeExpr",
            "start": ast_to_dict(node.start),
            "end": ast_to_dict(node.end),
        }

    if isinstance(node, BinaryExpr):
        return {
            "type": "BinaryExpr",
            "op": node.op,
            "left": ast_to_dict(node.left),
            "right": ast_to_dict(node.right),
        }

    raise TypeError(f"不支持的 AST 节点类型: {type(node)!r}")
