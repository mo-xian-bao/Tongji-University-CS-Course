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
    return_type: Optional[str]
    body: "Block"


@dataclass
class Param:
    is_mut: bool
    name: str
    type_name: str


@dataclass
class Block:
    statements: list["Statement"]


class Statement:
    pass


@dataclass
class EmptyStmt(Statement):
    pass


@dataclass
class LetStmt(Statement):
    is_mut: bool
    name: str
    type_name: Optional[str]


@dataclass
class AssignStmt(Statement):
    target_name: str
    value: "Expr"


@dataclass
class ReturnStmt(Statement):
    value: Optional["Expr"]


@dataclass
class IfStmt(Statement):
    condition: "Expr"
    then_block: Block
    else_block: Optional[Block]


@dataclass
class WhileStmt(Statement):
    condition: "Expr"
    body: Block


@dataclass
class ExprStmt(Statement):
    expr: "Expr"


class Expr:
    pass


@dataclass
class NumberExpr(Expr):
    value: int


@dataclass
class IdentifierExpr(Expr):
    name: str


@dataclass
class BinaryExpr(Expr):
    left: Expr
    op: str
    right: Expr


# ---------- AST 转字典，便于打印查看 ----------

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
            "return_type": node.return_type,
            "body": ast_to_dict(node.body),
        }

    if isinstance(node, Param):
        return {
            "type": "Param",
            "is_mut": node.is_mut,
            "name": node.name,
            "type_name": node.type_name,
        }

    if isinstance(node, Block):
        return {
            "type": "Block",
            "statements": [ast_to_dict(s) for s in node.statements],
        }

    if isinstance(node, EmptyStmt):
        return {"type": "EmptyStmt"}

    if isinstance(node, LetStmt):
        return {
            "type": "LetStmt",
            "is_mut": node.is_mut,
            "name": node.name,
            "type_name": node.type_name,
        }

    if isinstance(node, AssignStmt):
        return {
            "type": "AssignStmt",
            "target_name": node.target_name,
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
            "else_block": ast_to_dict(node.else_block) if node.else_block is not None else None,
        }

    if isinstance(node, WhileStmt):
        return {
            "type": "WhileStmt",
            "condition": ast_to_dict(node.condition),
            "body": ast_to_dict(node.body),
        }

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

    if isinstance(node, IdentifierExpr):
        return {
            "type": "IdentifierExpr",
            "name": node.name,
        }

    if isinstance(node, BinaryExpr):
        return {
            "type": "BinaryExpr",
            "op": node.op,
            "left": ast_to_dict(node.left),
            "right": ast_to_dict(node.right),
        }

    raise TypeError(f"不支持的 AST 节点类型: {type(node)!r}")
