from __future__ import annotations

import hashlib
from copy import deepcopy
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont
from docx import Document
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT
from docx.enum.text import (
    WD_ALIGN_PARAGRAPH,
    WD_BREAK,
    WD_LINE_SPACING,
    WD_TAB_ALIGNMENT,
    WD_TAB_LEADER,
)
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


ROOT = Path(r"D:\desktop\编译原理课程设计")
WORK = Path(r"D:\TEMP\USER_T~1\codex-documents\manual-20260722-rust-course")
REFERENCE = next((WORK / "template").glob("*.docx"))
OUTPUT = Path(__file__).resolve().parent / "updated_report.docx"
ARCHITECTURE_PNG = WORK / "architecture.png"
GUI_SHOTS = ROOT / "analyzer" / "tmp" / "report_gui_shots"
GUI_HOME_PNG = GUI_SHOTS / "01_home.png"
GUI_IR_PNG = GUI_SHOTS / "02_ir_workbench.png"
GUI_ASM_PNG = GUI_SHOTS / "03_assembly.png"
GUI_ERROR_PNG = GUI_SHOTS / "04_parse_error.png"
GUI_RUN_PNG = GUI_SHOTS / "05_exit_42.png"

BODY_WIDTH_DXA = 8300
TABLE_INDENT_DXA = 120
TABLE_WIDTH_DXA = BODY_WIDTH_DXA - TABLE_INDENT_DXA


def set_run_font(run, east_asia="宋体", latin="Times New Roman", size=None, bold=None, color=None):
    run.font.name = latin
    rpr = run._element.get_or_add_rPr()
    rfonts = rpr.get_or_add_rFonts()
    rfonts.set(qn("w:ascii"), latin)
    rfonts.set(qn("w:hAnsi"), latin)
    rfonts.set(qn("w:eastAsia"), east_asia)
    if size is not None:
        run.font.size = Pt(size)
    if bold is not None:
        run.bold = bold
    if color is not None:
        run.font.color.rgb = RGBColor.from_string(color)


def rewrite_paragraph(paragraph, text):
    if not paragraph.runs:
        paragraph.add_run(text)
        return
    paragraph.runs[0].text = text
    for run in paragraph.runs[1:]:
        run.text = ""


def trim_after_cover(doc):
    keep = doc.paragraphs[18]._p
    body = doc._element.body
    after = False
    for child in list(body):
        if child is keep:
            after = True
            continue
        if after and child.tag != qn("w:sectPr"):
            body.remove(child)
    doc.paragraphs[-1].add_run().add_break(WD_BREAK.PAGE)


def compress_cover(doc):
    for index, line_points in {
        0: 6,
        2: 6,
        4: 3,
        5: 3,
        7: 3,
        8: 3,
        14: 1,
        15: 1,
        16: 1,
        17: 1,
        18: 1,
    }.items():
        paragraph = doc.paragraphs[index]
        paragraph.paragraph_format.space_before = Pt(0)
        paragraph.paragraph_format.space_after = Pt(0)
        paragraph.paragraph_format.line_spacing_rule = WD_LINE_SPACING.EXACTLY
        paragraph.paragraph_format.line_spacing = Pt(line_points)
        for run in paragraph.runs:
            run.font.size = Pt(1)


def configure_document(doc):
    section = doc.sections[0]
    section.page_width = Inches(8.27)
    section.page_height = Inches(11.69)
    section.left_margin = Inches(1.25)
    section.right_margin = Inches(1.25)
    section.top_margin = Inches(1.0)
    section.bottom_margin = Inches(1.0)
    section.header_distance = Inches(0)
    section.footer_distance = Inches(0)

    normal = doc.styles["Normal"]
    normal.font.name = "Times New Roman"
    normal._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), "宋体")
    normal.font.size = Pt(10.5)
    normal.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    normal.paragraph_format.space_after = Pt(0)

    heading1 = doc.styles["Heading 1"]
    heading1.font.name = "Times New Roman"
    heading1._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), "宋体")
    heading1.font.size = Pt(15)
    heading1.font.bold = False
    heading1.font.color.rgb = RGBColor(0, 0, 0)
    heading1.paragraph_format.space_before = Pt(13)
    heading1.paragraph_format.space_after = Pt(6)

    heading2 = doc.styles["Heading 2"]
    heading2.font.name = "Times New Roman"
    heading2._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), "华文仿宋")
    heading2.font.size = Pt(14)
    heading2.font.bold = False
    heading2.font.color.rgb = RGBColor(0, 0, 0)
    heading2.paragraph_format.space_before = Pt(13)
    heading2.paragraph_format.space_after = Pt(6)

    heading3 = doc.styles["Heading 3"]
    heading3.font.name = "Times New Roman"
    heading3._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), "宋体")
    heading3.font.size = Pt(10.5)
    heading3.font.bold = True
    heading3.font.color.rgb = RGBColor(0, 0, 0)
    heading3.paragraph_format.space_before = Pt(6)
    heading3.paragraph_format.space_after = Pt(3.1)


def add_center_title(doc, text, size=16):
    paragraph = doc.add_paragraph(style="Normal")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    paragraph.paragraph_format.space_after = Pt(12)
    run = paragraph.add_run(text)
    set_run_font(run, east_asia="黑体", size=size, bold=True)
    return paragraph


def add_toc_entry(doc, title, page, level=1):
    paragraph = doc.add_paragraph(style="Normal")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.LEFT
    paragraph.paragraph_format.first_line_indent = Pt(0)
    paragraph.paragraph_format.left_indent = Pt(0 if level == 1 else 18)
    paragraph.paragraph_format.space_before = Pt(0)
    paragraph.paragraph_format.space_after = Pt(0)
    paragraph.paragraph_format.line_spacing_rule = WD_LINE_SPACING.EXACTLY
    paragraph.paragraph_format.line_spacing = Pt(11)
    paragraph.paragraph_format.tab_stops.add_tab_stop(
        Inches(5.62), WD_TAB_ALIGNMENT.RIGHT, WD_TAB_LEADER.DOTS
    )
    run = paragraph.add_run(f"{title}\t{page}")
    set_run_font(run, size=10.5 if level == 1 else 9.5, bold=(level == 1))
    return paragraph


def add_static_toc(doc):
    first = [
        ("一、课程设计概述", 5, 1),
        ("1.1 背景与目的", 5, 2),
        ("1.2 任务范围", 5, 2),
        ("1.3 开发与运行环境", 5, 2),
        ("1.4 交付物与验收目标", 6, 2),
        ("二、需求分析", 7, 1),
        ("2.1 可行性分析", 7, 2),
        ("2.2 功能需求", 7, 2),
        ("2.3 非功能需求", 7, 2),
        ("2.4 文法规则覆盖与优秀档策略", 8, 2),
        ("2.5 验收准则", 8, 2),
        ("三、总体方案设计", 10, 1),
        ("3.1 总体架构与数据流", 10, 2),
        ("3.2 对“一遍”的实现定义", 10, 2),
        ("3.3 模块职责与接口", 11, 2),
        ("3.4 核心数据结构", 11, 2),
        ("3.5 错误模型与输出策略", 11, 2),
        ("四、前端与语法制导翻译详细设计", 12, 1),
        ("4.1 按需词法分析", 12, 2),
        ("4.2 递归下降与有限前看", 12, 2),
        ("4.3 表达式优先级与左递归消除", 12, 2),
        ("4.4 函数归约点的语义动作", 13, 2),
        ("4.5 声明、赋值和函数调用翻译", 13, 2),
        ("4.6 控制流翻译与回填", 13, 2),
        ("4.7 块、if 与 loop 表达式", 14, 2),
        ("五、静态语义与复合类型", 15, 1),
        ("5.1 函数表、作用域栈与初始化", 15, 2),
        ("5.2 类型推导、函数调用和返回路径", 15, 2),
        ("5.3 不可变性与借用模型", 15, 2),
        ("5.4 数组、元组与边界检查", 15, 2),
        ("5.5 错误定位示例", 16, 2),
    ]
    second = [
        ("六、中间代码与目标代码", 17, 1),
        ("6.1 四元式模型与指令集", 17, 2),
        ("6.2 典型翻译示例", 17, 2),
        ("6.3 IR 与汇编文件格式", 17, 2),
        ("6.4 x86-64 栈帧与 Windows ABI", 18, 2),
        ("6.5 主要指令映射", 18, 2),
        ("6.6 汇编、链接与可执行输出", 18, 2),
        ("6.7 目标后端边界", 19, 2),
        ("七、程序实现与使用", 20, 1),
        ("7.1 项目目录", 20, 2),
        ("7.2 关键类与函数索引", 20, 2),
        ("7.3 命令行参数", 21, 2),
        ("7.4 独立程序打包", 21, 2),
        ("7.5 可视化演示器首页与工作台", 22, 2),
        ("7.6 目标代码与错误诊断展示", 24, 2),
        ("7.7 汇编运行与退出码", 25, 2),
        ("八、测试设计与实验结果", 26, 1),
        ("8.1 分层测试策略", 26, 2),
        ("8.2 44 组回归结果", 26, 2),
        ("8.3 综合样例覆盖", 27, 2),
        ("8.4 关键缺陷的回归证据", 27, 2),
        ("8.5 源码入口与打包程序交叉验证", 27, 2),
        ("8.6 测试局限", 28, 2),
        ("九、问题解决与 AI 辅助历程", 29, 1),
        ("9.1 从分离流水线改为 Parser 主控", 29, 2),
        ("9.2 控制流与重影缺陷", 29, 2),
        ("9.3 借用、返回与边界规则补强", 29, 2),
        ("9.4 目标后端中的工程问题", 29, 2),
        ("9.5 AI 工具使用披露", 29, 2),
        ("9.6 对 AI 辅助的反思", 30, 2),
        ("十、总结与展望", 31, 1),
        ("10.1 工作总结", 31, 2),
        ("10.2 后续工作", 31, 2),
        ("10.3 设计体会", 31, 2),
        ("参考资料", 32, 1),
        ("附录 A：核心文法摘要", 33, 1),
        ("附录 B：复现实验命令", 34, 1),
    ]
    add_center_title(doc, "目  录")
    for title, page, level in first:
        add_toc_entry(doc, title, page, level)
    doc.paragraphs[-1].add_run().add_break(WD_BREAK.PAGE)
    add_center_title(doc, "目  录（续）")
    for title, page, level in second:
        add_toc_entry(doc, title, page, level)
    doc.paragraphs[-1].add_run().add_break(WD_BREAK.PAGE)


def add_body(doc, text, indent=True, bold_lead=None):
    paragraph = doc.add_paragraph(style="Normal")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    paragraph.paragraph_format.first_line_indent = Pt(21) if indent else Pt(0)
    paragraph.paragraph_format.space_after = Pt(0)
    if bold_lead and text.startswith(bold_lead):
        run = paragraph.add_run(bold_lead)
        set_run_font(run, bold=True)
        run = paragraph.add_run(text[len(bold_lead):])
        set_run_font(run)
    else:
        run = paragraph.add_run(text)
        set_run_font(run)
    return paragraph


def add_heading(doc, text, level, page_break=False):
    paragraph = doc.add_paragraph(text, style=f"Heading {level}")
    paragraph.paragraph_format.keep_with_next = True
    if page_break:
        paragraph.paragraph_format.page_break_before = True
    for run in paragraph.runs:
        if level == 1:
            set_run_font(run, east_asia="宋体", size=15, bold=False)
        elif level == 2:
            set_run_font(run, east_asia="华文仿宋", size=14, bold=False)
        else:
            set_run_font(run, east_asia="宋体", size=10.5, bold=True)
    return paragraph


def _next_numbering_ids(doc):
    root = doc.part.numbering_part.element
    abstract_ids = [int(node.get(qn("w:abstractNumId"))) for node in root.findall(qn("w:abstractNum"))]
    num_ids = [int(node.get(qn("w:numId"))) for node in root.findall(qn("w:num"))]
    return (max(abstract_ids, default=0) + 1, max(num_ids, default=0) + 1)


def _create_numbering(doc, bullet=False):
    root = doc.part.numbering_part.element
    abstract_id, num_id = _next_numbering_ids(doc)
    abstract = OxmlElement("w:abstractNum")
    abstract.set(qn("w:abstractNumId"), str(abstract_id))
    multi = OxmlElement("w:multiLevelType")
    multi.set(qn("w:val"), "singleLevel")
    abstract.append(multi)
    lvl = OxmlElement("w:lvl")
    lvl.set(qn("w:ilvl"), "0")
    start = OxmlElement("w:start")
    start.set(qn("w:val"), "1")
    lvl.append(start)
    num_fmt = OxmlElement("w:numFmt")
    num_fmt.set(qn("w:val"), "bullet" if bullet else "decimal")
    lvl.append(num_fmt)
    lvl_text = OxmlElement("w:lvlText")
    lvl_text.set(qn("w:val"), "•" if bullet else "%1.")
    lvl.append(lvl_text)
    lvl_jc = OxmlElement("w:lvlJc")
    lvl_jc.set(qn("w:val"), "left")
    lvl.append(lvl_jc)
    ppr = OxmlElement("w:pPr")
    tabs = OxmlElement("w:tabs")
    tab = OxmlElement("w:tab")
    tab.set(qn("w:val"), "num")
    tab.set(qn("w:pos"), "420")
    tabs.append(tab)
    ppr.append(tabs)
    ind = OxmlElement("w:ind")
    ind.set(qn("w:left"), "420")
    ind.set(qn("w:hanging"), "210")
    ppr.append(ind)
    lvl.append(ppr)
    if bullet:
        rpr = OxmlElement("w:rPr")
        rfonts = OxmlElement("w:rFonts")
        rfonts.set(qn("w:ascii"), "Symbol")
        rfonts.set(qn("w:hAnsi"), "Symbol")
        rpr.append(rfonts)
        lvl.append(rpr)
    abstract.append(lvl)
    root.append(abstract)
    num = OxmlElement("w:num")
    num.set(qn("w:numId"), str(num_id))
    ref = OxmlElement("w:abstractNumId")
    ref.set(qn("w:val"), str(abstract_id))
    num.append(ref)
    root.append(num)
    return num_id


def add_list(doc, items, num_id):
    for item in items:
        paragraph = doc.add_paragraph(style="Normal")
        paragraph.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        paragraph.paragraph_format.space_after = Pt(0)
        paragraph.paragraph_format.keep_together = True
        num_pr = paragraph._p.get_or_add_pPr().get_or_add_numPr()
        ilvl = OxmlElement("w:ilvl")
        ilvl.set(qn("w:val"), "0")
        num = OxmlElement("w:numId")
        num.set(qn("w:val"), str(num_id))
        num_pr.append(ilvl)
        num_pr.append(num)
        run = paragraph.add_run(item)
        set_run_font(run)


def set_cell_margins(cell, top=70, start=100, bottom=70, end=100):
    tc_pr = cell._tc.get_or_add_tcPr()
    tc_mar = tc_pr.first_child_found_in("w:tcMar")
    if tc_mar is None:
        tc_mar = OxmlElement("w:tcMar")
        tc_pr.append(tc_mar)
    for edge, value in (("top", top), ("start", start), ("bottom", bottom), ("end", end)):
        tag = qn(f"w:{edge}")
        node = tc_mar.find(tag)
        if node is None:
            node = OxmlElement(f"w:{edge}")
            tc_mar.append(node)
        node.set(qn("w:w"), str(value))
        node.set(qn("w:type"), "dxa")


def set_cell_shading(cell, fill):
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = tc_pr.find(qn("w:shd"))
    if shd is None:
        shd = OxmlElement("w:shd")
        tc_pr.append(shd)
    shd.set(qn("w:fill"), fill)


def set_table_borders(table, color="000000", size="4"):
    tbl_pr = table._tbl.tblPr
    borders = tbl_pr.find(qn("w:tblBorders"))
    if borders is None:
        borders = OxmlElement("w:tblBorders")
        tbl_pr.append(borders)
    for edge in ("top", "left", "bottom", "right", "insideH", "insideV"):
        node = borders.find(qn(f"w:{edge}"))
        if node is None:
            node = OxmlElement(f"w:{edge}")
            borders.append(node)
        node.set(qn("w:val"), "single")
        node.set(qn("w:sz"), size)
        node.set(qn("w:color"), color)


def set_table_geometry(table, widths):
    assert sum(widths) == TABLE_WIDTH_DXA
    table.autofit = False
    tbl_pr = table._tbl.tblPr
    for tag_name, attrs in (
        ("w:tblW", {"w:w": str(TABLE_WIDTH_DXA), "w:type": "dxa"}),
        ("w:tblInd", {"w:w": str(TABLE_INDENT_DXA), "w:type": "dxa"}),
        ("w:tblLayout", {"w:type": "fixed"}),
    ):
        node = tbl_pr.find(qn(tag_name))
        if node is None:
            node = OxmlElement(tag_name)
            tbl_pr.append(node)
        for key, value in attrs.items():
            node.set(qn(key), value)
    grid = table._tbl.tblGrid
    for child in list(grid):
        grid.remove(child)
    for width in widths:
        col = OxmlElement("w:gridCol")
        col.set(qn("w:w"), str(width))
        grid.append(col)
    for row in table.rows:
        cant_split = OxmlElement("w:cantSplit")
        row._tr.get_or_add_trPr().append(cant_split)
        for cell, width in zip(row.cells, widths):
            tc_pr = cell._tc.get_or_add_tcPr()
            tc_w = tc_pr.find(qn("w:tcW"))
            if tc_w is None:
                tc_w = OxmlElement("w:tcW")
                tc_pr.append(tc_w)
            tc_w.set(qn("w:w"), str(width))
            tc_w.set(qn("w:type"), "dxa")
            set_cell_margins(cell)


def add_table(doc, headers, rows, widths, alignments=None, font_size=9.5):
    table = doc.add_table(rows=1, cols=len(headers))
    set_table_geometry(table, widths)
    set_table_borders(table)
    header_row = table.rows[0]
    tbl_header = OxmlElement("w:tblHeader")
    header_row._tr.get_or_add_trPr().append(tbl_header)
    for index, text in enumerate(headers):
        cell = header_row.cells[index]
        set_cell_shading(cell, "D9D9D9")
        cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
        paragraph = cell.paragraphs[0]
        paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
        paragraph.paragraph_format.space_after = Pt(0)
        run = paragraph.add_run(str(text))
        set_run_font(run, size=font_size, bold=True)
    for row_data in rows:
        cells = table.add_row().cells
        for index, value in enumerate(row_data):
            cell = cells[index]
            cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
            paragraph = cell.paragraphs[0]
            alignment = alignments[index] if alignments else WD_ALIGN_PARAGRAPH.LEFT
            paragraph.alignment = alignment
            paragraph.paragraph_format.space_after = Pt(0)
            run = paragraph.add_run(str(value))
            set_run_font(run, size=font_size)
    set_table_geometry(table, widths)
    set_table_borders(table)
    doc.add_paragraph(style="Normal").paragraph_format.space_after = Pt(0)
    return table


def add_code_block(doc, code, font_size=9.0):
    table = doc.add_table(rows=1, cols=1)
    set_table_geometry(table, [TABLE_WIDTH_DXA])
    set_table_borders(table, color="666666", size="4")
    cell = table.cell(0, 0)
    set_cell_shading(cell, "F2F2F2")
    set_cell_margins(cell, top=100, start=140, bottom=100, end=140)
    paragraph = cell.paragraphs[0]
    paragraph.alignment = WD_ALIGN_PARAGRAPH.LEFT
    paragraph.paragraph_format.first_line_indent = Pt(0)
    paragraph.paragraph_format.line_spacing_rule = WD_LINE_SPACING.SINGLE
    paragraph.paragraph_format.space_after = Pt(0)
    run = paragraph.add_run(code.strip("\n"))
    set_run_font(run, east_asia="微软雅黑", latin="Consolas", size=font_size)
    return table


def add_caption(doc, text):
    paragraph = doc.add_paragraph(style="Caption")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    paragraph.paragraph_format.keep_with_next = False
    paragraph.paragraph_format.space_before = Pt(3)
    paragraph.paragraph_format.space_after = Pt(6)
    run = paragraph.add_run(text)
    set_run_font(run, size=10.5)
    return paragraph


def _font(size, bold=False):
    candidates = [
        Path(r"C:\Windows\Fonts\msyhbd.ttc" if bold else r"C:\Windows\Fonts\msyh.ttc"),
        Path(r"C:\Windows\Fonts\simhei.ttf"),
        Path(r"C:\Windows\Fonts\simsun.ttc"),
    ]
    for candidate in candidates:
        if candidate.exists():
            return ImageFont.truetype(str(candidate), size=size)
    return ImageFont.load_default()


def draw_architecture():
    image = Image.new("RGB", (1500, 650), "white")
    draw = ImageDraw.Draw(image)
    title_font = _font(34, bold=True)
    body_font = _font(25)
    small_font = _font(21)
    draw.text((750, 24), "一遍式类 Rust 编译器总体数据流", font=title_font, fill="#111111", anchor="ma")

    def box(x, y, w, h, text, fill="#F3F3F3", border="#333333"):
        draw.rounded_rectangle((x, y, x + w, y + h), radius=14, fill=fill, outline=border, width=3)
        draw.multiline_text((x + w / 2, y + h / 2), text, font=body_font, fill="#111111", anchor="mm", align="center", spacing=4)

    def arrow(x1, y1, x2, y2, label=None):
        draw.line((x1, y1, x2, y2), fill="#333333", width=4)
        angle = 12
        draw.polygon([(x2, y2), (x2 - 16, y2 - angle), (x2 - 16, y2 + angle)], fill="#333333")
        if label:
            draw.text(((x1 + x2) / 2, y1 - 13), label, font=small_font, fill="#333333", anchor="ms")

    box(45, 130, 170, 88, "源程序")
    box(280, 130, 210, 88, "Parser\n递归下降主控", fill="#E9EEF8")
    box(555, 130, 210, 88, "Function AST")
    box(830, 130, 210, 88, "语义动作\nCodeGenerator", fill="#EAF4EA")
    box(1105, 130, 210, 88, "IRFunction")
    arrow(215, 174, 280, 174)
    arrow(490, 174, 555, 174, "完成一个函数")
    arrow(765, 174, 830, 174, "回调")
    arrow(1040, 174, 1105, 174)

    box(280, 290, 210, 88, "Lexer.next_token\n按需扫描", fill="#FFF2CC")
    draw.line((385, 218, 385, 290), fill="#333333", width=4)
    draw.polygon([(385, 290), (373, 272), (397, 272)], fill="#333333")
    draw.text((410, 258), "需要下一个符号", font=small_font, fill="#333333", anchor="lm")

    box(45, 485, 190, 88, "Program AST")
    box(285, 485, 205, 88, "SemanticAnalyzer\n语义门禁", fill="#FCE8E8")
    box(540, 485, 175, 88, "IRProgram")
    box(765, 485, 220, 88, "AssemblyGenerator\nx86-64", fill="#E9EEF8")
    box(1035, 485, 170, 88, ".ir / .s")
    box(1255, 485, 185, 88, "GCC → .exe", fill="#EAF4EA")
    arrow(235, 529, 285, 529)
    arrow(490, 529, 540, 529, "通过")
    arrow(715, 529, 765, 529)
    arrow(985, 529, 1035, 529)
    arrow(1205, 529, 1255, 529)
    draw.line((1210, 218, 1210, 425), fill="#666666", width=3)
    draw.line((1210, 425, 627, 425), fill="#666666", width=3)
    draw.line((627, 425, 627, 485), fill="#666666", width=3)
    draw.polygon([(627, 485), (615, 467), (639, 467)], fill="#666666")
    draw.text((934, 413), "函数级 IR 汇总；语义失败则不落盘", font=small_font, fill="#555555", anchor="ms")
    image.save(ARCHITECTURE_PNG)


def add_architecture(doc):
    draw_architecture()
    paragraph = doc.add_paragraph(style="Normal")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = paragraph.add_run()
    run.add_picture(str(ARCHITECTURE_PNG), width=Inches(5.72))
    add_caption(doc, "图 3-1 一遍式编译器总体数据流")


def add_figure(doc, image_path, caption, width=5.72):
    if not image_path.exists():
        raise FileNotFoundError(f"截图不存在: {image_path}")
    paragraph = doc.add_paragraph(style="Normal")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    paragraph.paragraph_format.first_line_indent = Pt(0)
    paragraph.paragraph_format.space_before = Pt(3)
    paragraph.paragraph_format.space_after = Pt(0)
    paragraph.paragraph_format.keep_with_next = True
    run = paragraph.add_run()
    run.add_picture(str(image_path), width=Inches(width))
    return add_caption(doc, caption)


def build():
    reference_hash = hashlib.sha256(REFERENCE.read_bytes()).hexdigest().upper()
    expected = "0E7EA6B86F53C93DB544C84FD5B601C24D84E02BF340EE519AC80493AA16745A"
    if reference_hash != expected:
        raise RuntimeError("参考 DOCX 已变化，必须重新提炼模板")

    doc = Document(REFERENCE)
    rewrite_paragraph(doc.paragraphs[1], "同济大学计算机系")
    rewrite_paragraph(doc.paragraphs[3], "类 Rust 一遍式编译器实验报告")
    rewrite_paragraph(doc.paragraphs[9], "专    业      \t计算机科学与技术\t")
    rewrite_paragraph(doc.paragraphs[10], "组    员      \t________________\t")
    rewrite_paragraph(doc.paragraphs[11], "组    员      \t________________\t")
    rewrite_paragraph(doc.paragraphs[12], "组    员      \t________________\t")
    rewrite_paragraph(doc.paragraphs[13], "授课老师    \t卫志华、高珍老师\t")
    compress_cover(doc)
    trim_after_cover(doc)
    configure_document(doc)
    bullet_id = _create_numbering(doc, bullet=True)
    number_id = _create_numbering(doc, bullet=False)

    add_center_title(doc, "摘  要")
    add_body(doc, "本课程设计在既有类 Rust 语言词法、语法、语义分析与四元式生成器基础上，按照 2026 年课程设计附件完成了一体化改造。系统以手写递归下降语法分析器为主控，词法分析器不再预先扫描整个文件，而是通过 Lexer.next_token() 在语法分析需要时提供下一个记号；每解析完成一个函数声明，解析器立即触发语义动作生成对应 IRFunction，从而形成函数粒度的语法制导翻译。完整程序随后经过符号表、类型、可变性、借用、控制流和返回路径检查，只有语义门禁通过时才写出中间代码与目标代码文件。")
    add_body(doc, "目标代码后端将四元式降低为 GNU Intel 语法的 x86-64 Windows 汇编：标量与临时值分配栈槽，数组和元组采用连续存储，函数调用遵循前四参数寄存器与 32 字节 shadow space 规则，引用保存栈地址，数组访问在长度可知时插入运行时上下界检查。生成的 .s 文件可由 GCC 直接汇编链接为 .exe；综合示例覆盖分支、循环、数组、元组、借用、块表达式和函数调用，执行退出码为 42。")
    add_body(doc, "实现过程中还补齐了不可变变量首次初始化、可变借用互斥、缺失返回路径、数组/元组越界等语义规则，并修复 for 循环中 continue 跳过自增以及变量重影导致 IR 栈槽同名覆盖等深层缺陷。在编译核心之外，系统新增蓝白渐变可视化演示器，可编辑或载入示例，并在停止输入后同步显示 Token、AST、四元式、x86-64 汇编、诊断与运行结果。最终核心 44 组回归与 10 项 GUI 专项检查全部通过，综合示例经 GCC 执行的退出码为 42。")
    keyword = doc.add_paragraph(style="Normal")
    keyword.paragraph_format.first_line_indent = Pt(0)
    keyword.paragraph_format.space_before = Pt(10)
    run = keyword.add_run("关键词：")
    set_run_font(run, bold=True)
    run = keyword.add_run("类 Rust；一遍编译；递归下降；语法制导翻译；四元式；x86-64；可视化演示器")
    set_run_font(run)
    keyword.add_run().add_break(WD_BREAK.PAGE)

    add_static_toc(doc)

    add_heading(doc, "一、课程设计概述", 1)
    add_heading(doc, "1.1 背景与目的", 2)
    add_body(doc, "编译器把高级语言源程序逐步转换为机器可执行形式。课程设计要求不仅理解词法、语法、符号表和中间代码等独立概念，还要把这些概念组织成可运行、可验证、可解释的完整系统。类 Rust 语言同时包含常见的函数、变量、表达式与控制流，又引入 mut、引用、数组、元组和表达式块等语义约束，适合作为编译原理综合训练对象。")
    add_body(doc, "本项目的首要目标是把之前相互分离的词法分析和语法分析改造成语法主控的一遍式工作流；第二个目标是在语法分析过程中以函数为单位执行中间代码语义动作；第三个目标是补足目标代码后端，使输出不止停留在四元式，而能进一步形成可由 GCC 汇编链接的 x86-64 程序；最后通过自动回归和综合程序执行证明各阶段连接正确。")
    add_heading(doc, "1.2 任务范围", 2)
    add_list(doc, [
        "输入 UTF-8 编码的类 Rust 源文件，按需完成词法识别并提供包含行列信息的 Token。",
        "采用递归下降方法构造 AST，支持附件 0.1–9.3 中的函数、声明、表达式、分支、循环、引用、数组、元组和表达式块。",
        "建立函数表与块级作用域栈，执行类型推导、初始化、可变性、借用、调用、返回路径和边界检查。",
        "在函数归约点生成四元式 IR，语义检查通过后写入 .ir 文件。",
        "把 IR 降低为 x86-64 GNU Intel 汇编，写入 .s 文件，并可选调用 GCC 生成 .exe。",
        "提供蓝白渐变可视化演示器、独立 Windows GUI/CLI 程序、综合样例、动态结果、错误定位和自动回归测试。",
    ], bullet_id)
    add_heading(doc, "1.3 开发与运行环境", 2)
    add_table(doc, ["项目", "配置/版本", "用途"], [
        ["实现语言", "Python 3.10+（GUI 打包使用 3.11）", "编译器前端、IR、汇编后端和测试驱动"],
        ["可视化界面", "Tkinter/ttk 8.6", "蓝白渐变首页、源码编辑器、分阶段结果与诊断"],
        ["汇编链接", "MSYS2 GCC 15.1", "将 GNU Intel x86-64 .s 链接为 Windows .exe"],
        ["独立打包", "PyInstaller 6.15", "生成无控制台 GUI 与独立 CLI 单文件程序"],
        ["办公与验收", "Word/LibreOffice、PowerPoint", "设计报告与答辩材料的渲染检查"],
        ["运行平台", "Windows x86-64 / PowerShell", "GUI、CLI、GCC、退出码验证"],
    ], [1500, 2600, 4080], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])
    add_heading(doc, "1.4 交付物与验收目标", 2)
    add_body(doc, "课程附件要求提交源程序、编译器可执行程序和设计说明书。本工作区对应交付为 analyzer 源码目录、dist/rust_like_compiler.exe 可视化演示器、dist/rust_like_compiler_cli.exe 命令行程序、完整 README、本实验报告和汇报 PPT。验收同时保留可复现命令与界面证据：核心回归和 GUI 专项测试必须全部通过；综合程序必须生成 IR、汇编与可执行文件；目标程序退出码必须等于 42；编译错误必须在界面中标出阶段并清除旧结果。")

    add_heading(doc, "二、需求分析", 1, page_break=True)
    add_heading(doc, "2.1 可行性分析", 2)
    add_body(doc, "技术上，既有项目已经具备 Token、AST、语义检查和四元式结构，重构的主要风险集中在扫描接口、语法制导时机和目标代码映射。按需 Lexer 可以在不改变文法函数结构的前提下替换预扫描 Token 列表；函数级 IR 生成不依赖全局类型信息，适合在 FunctionDecl 解析完成后执行；x86-64 后端以已有四元式为输入，可以独立实现和测试。因此本项目无需推倒重写，符合最小改造原则。")
    add_body(doc, "工程上，Python 标准库即可完成主体实现，GCC 与 PyInstaller 只用于可选汇编链接和独立打包。测试方面，原有示例可作为回归基线，并可增加内存中的专项用例验证借用、越界和返回路径。时间上，各模块接口明确，可以按“扫描接口→语法回调→语义补强→后端→端到端测试”的顺序分阶段验收。")
    add_heading(doc, "2.2 功能需求", 2)
    add_table(doc, ["编号", "需求", "可验证结果"], [
        ["FR-01", "语法分析按需调用词法子程序", "Parser 持有 Lexer；_ensure_token 才调用 next_token"],
        ["FR-02", "一遍顺序扫描源程序", "不预先 tokenize；局部回溯仅复用已缓存 Token"],
        ["FR-03", "语法制导生成中间代码", "每完成 FunctionDecl 触发 on_function 回调"],
        ["FR-04", "生成并保存 IR", "语义通过后写出同名 .ir 文件"],
        ["FR-05", "生成可汇编目标代码", "写出 .s；GCC 生成并运行 .exe"],
        ["FR-06", "覆盖类 Rust 文法与语义", "规则 0.1–9.3 均有实现与测试证据"],
        ["FR-07", "提供错误诊断", "词法/语法含行列、源码行和插入符；语义错误分类清晰"],
        ["FR-08", "提供双击常驻的可视化程序", "无控制台 GUI 可编辑源码并动态显示 Token/AST/IR/汇编"],
        ["FR-09", "保留自动化命令行入口", "独立 CLI 单文件程序继续支持原有参数"],
    ], [900, 3000, 4280], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])
    add_heading(doc, "2.3 非功能需求", 2)
    add_list(doc, [
        "正确性：合法程序各阶段输出稳定；非法程序不得写出可误用的最终产物。",
        "可解释性：Parser、SemanticAnalyzer、CodeGenerator、AssemblyGenerator 之间有清晰职责边界。",
        "可测试性：阶段结果均可独立检查，CLI 返回码可被脚本消费。",
        "可用性：主程序双击后常驻，示例与自定义源码使用同一工作台，失败状态不能显示上一版结果。",
        "可移植性：不生成汇编时无第三方 Python 依赖；汇编后端明确限定 Windows x86-64。",
        "可维护性：改造保持已有 AST 和 IR 数据模型，避免为课程范围引入不必要框架。",
    ], bullet_id)
    add_heading(doc, "2.4 文法规则覆盖与优秀档策略", 2)
    add_table(doc, ["规则组", "实现内容", "状态"], [
        ["0.1–1.5", "mut、i32、左值、多函数、空语句、参数、返回类型", "完成"],
        ["2.0–2.3", "声明、延迟推断、赋值、声明初始化、重影", "完成"],
        ["3.1–4.3", "优先级表达式、调用、if/else/else-if", "完成"],
        ["5.0–5.4", "while、范围/数组 for、loop、break、continue", "完成"],
        ["6.1–6.4", "不可变性、不可变/可变引用、借用与解引用", "完成"],
        ["7.0–7.4", "块表达式、函数尾表达式、if/loop 表达式", "完成"],
        ["8.1–8.3", "定长数组、字面量、迭代、下标读写与越界", "完成"],
        ["9.1–9.3", "元组类型、表达式、数字字段读写与越界", "完成"],
        ["目标代码", "x86-64 汇编、GCC 链接、可执行程序", "完成"],
    ], [1200, 5700, 1280], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER])
    add_body(doc, "按附件星级分组，5.x、6.x、7.x、8.x 和 9.x 扩展均已覆盖，远高于申请优秀所需的 7 星门槛。附件评分页写有 7.1–7.5，但正文仅定义到 7.4；本实现以正文实际规则 7.0–7.4 为准，并在报告中保留这一源稿疑点。")
    add_heading(doc, "2.5 验收准则", 2)
    add_list(doc, [
        "python -m compileall -q src run.py run_regression.py 返回 0。",
        "python run_regression.py 输出 44 个 [PASS]，末尾为 Regression passed。",
        "综合样例 course_full.rs 生成 course_full.ir、course_full.s 和 course_full.exe。",
        "运行 course_full.exe 后 PowerShell 的 $LASTEXITCODE 等于 42。",
        "dist/rust_like_compiler.exe 能独立完成相同编译链路。",
        "GUI 双击无黑色控制台，输入停顿后动态刷新；综合示例经界面运行的退出码为 42。",
    ], number_id)

    add_heading(doc, "三、总体方案设计", 1, page_break=True)
    add_heading(doc, "3.1 总体架构与数据流", 2)
    add_body(doc, "系统采用“语法主控、函数级翻译、程序级语义门禁、后端独立降低”的结构。Parser 仅在当前 Token 不足时向 Lexer 请求下一个记号；FunctionDecl 完成后立即交给 CodeGenerator 生成 IRFunction；全部函数构成 Program AST 后，SemanticAnalyzer 先收集签名再逐函数检查。只有语义通过，IRProgram 才进入文件输出和目标后端。")
    add_architecture(doc)
    add_heading(doc, "3.2 对“一遍”的实现定义", 2)
    add_body(doc, "本项目中的“一遍”指词法和语法只按源文件方向顺序推进一次，不再先独立生成完整 Token 文件、再启动第二套扫描。Parser 为了区分“块末尾表达式”和“表达式语句”会进行有限局部试探；试探失败时只回退 Token 索引，已经扫描的字符与 Token 保留在缓存中，不会让 Lexer 回退或重新扫描源字符串。因此源字符流仍只被词法器消费一次。")
    add_body(doc, "中间代码的语义动作位于函数声明归约点，而不是等整个 AST 完成后统一遍历。考虑到课程文法允许调用后定义函数，静态语义仍保留程序级签名收集与校验阶段。这一边界既满足“语法分析同时生成 IR”的要求，也避免为了形式上的单阶段而牺牲前向调用和清晰错误诊断。")
    add_heading(doc, "3.3 模块职责与接口", 2)
    add_table(doc, ["模块", "输入", "输出", "核心职责"], [
        ["lexer.py", "源码字符", "Token", "空白/注释跳过、最长匹配、行列维护、next_token"],
        ["parser.py", "Lexer/Token", "AST", "递归下降、优先级、有限前看、函数完成回调"],
        ["semantic.py", "Program AST", "通过/错误", "函数表、作用域、类型、借用、边界、返回路径"],
        ["codegen.py", "FunctionDecl", "IRFunction", "语法结构到四元式、临时变量、标签和回填"],
        ["target.py", "IRProgram", "x86-64 文本", "栈布局、ABI、指令选择、边界检查"],
        ["compiler.py", "源码", "CompilationResult", "协调各阶段、文件写出和 GCC 调用"],
        ["run.py/main.py", "CLI 参数", "终端/文件", "用户入口、显示开关、退出码"],
        ["run_regression.py", "样例/内存程序", "PASS/FAIL", "44 组回归与端到端执行"],
    ], [1400, 1350, 1400, 4030], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT], font_size=9)
    add_heading(doc, "3.4 核心数据结构", 2)
    add_list(doc, [
        "Token(kind, lexeme, line, column)：保留类别、原词素与定位信息。",
        "AST：Program、FunctionDecl、Block、语句节点、表达式节点和 TypeNode 层次。",
        "VariableSymbol：记录类型、mut、初始化状态和当前借用计数；作用域使用字典栈。",
        "Quad(op, arg1, arg2, result)：统一表达算术、控制流、调用、引用和复合类型操作。",
        "IRFunction/IRProgram：保存函数参数与四元式序列，作为目标后端输入。",
        "FrameLayout：保存 IR 名称到 rbp 偏移、复合对象 backing 区域、长度和总帧大小。",
    ], bullet_id)
    add_heading(doc, "3.5 错误模型与输出策略", 2)
    add_body(doc, "LexerError、ParserError、SemanticError、CodeGenerationError 与 TargetCodeError 均继承 CompilerError。run_file 捕获编译阶段错误、文件错误和 GCC 子进程错误，成功返回 0，失败返回 1。词法与语法错误保留源代码行并用插入符标出列位置；语义与后端错误给出违反的规则和对象名称。")
    add_body(doc, "输出采用事务式门禁：Compiler.compile 先完成 AST、函数级 IR、语义检查和汇编文本构造，write_outputs 只在整个调用成功后创建目录并写出 .ir/.s；--assemble 在文件写出后调用 GCC。这样语义失败不会留下看似成功的最终目标文件。")

    add_heading(doc, "四、前端与语法制导翻译详细设计", 1, page_break=True)
    add_heading(doc, "4.1 按需词法分析", 2)
    add_body(doc, "Lexer 保存 source、index、line、column、emitted_tokens 和 finished 状态。next_token 每次跳过空白与注释后只识别一个 Token：标识符先完整读取再查关键字表；数字连续读取十进制字符；双字符运算符 ->、==、!=、>=、<=、.. 优先于单字符符号，符合最长匹配原则；非法字符和未闭合块注释立即抛出 LexerError。")
    add_code_block(doc, """def _ensure_token(self, index: int) -> None:
    while self.token_source is not None and len(self.tokens) <= index:
        token = self.token_source.next_token()
        self.tokens.append(token)
        if token.kind == TokenKind.EOF:
            break""")
    add_body(doc, "Parser 的 current、check 和 lookahead 最终都通过 _ensure_token 请求 Token。若构造 Parser 时传入的是旧式 Token 列表，接口仍可用于回归测试；正式编译入口始终传入 Lexer 实例。到达 EOF 后 Lexer 重复返回同一个 EOF，避免越界并保证终止。")
    add_heading(doc, "4.2 递归下降与有限前看", 2)
    add_body(doc, "每个主要非终结符对应一个解析函数：parse_program 读取函数串，_parse_function_decl 读取函数头和块，_parse_statement 根据首符选择声明、return、if、循环或表达式语句，_parse_type 递归解析引用、数组和元组类型。expect 负责消费预期 Token，失败时结合当前位置构造 ParserError。")
    add_body(doc, "块文法允许最后一个无分号表达式作为块值。解析器先记住 pos，尝试解析表达式；若其后紧接右花括号，就把表达式存入 Block.result；否则恢复 pos 再按普通语句解析。由于恢复的是 Token 索引而不是 Lexer 字符位置，前看不会造成字符流二次扫描。")
    add_heading(doc, "4.3 表达式优先级与左递归消除", 2)
    add_body(doc, "附件表达式产生式包含左递归，不能直接翻译为递归下降函数。实现把比较、加减、乘除分别改写为“较高优先级子表达式 + 零个或多个运算后缀”，在 while 循环中构造左结合 BinaryExpr。后缀层再处理调用、数组下标和元组字段，因此 a + b * c[0] 会先完成下标与乘法，再形成加法根节点。")
    add_code_block(doc, """comparison ::= additive (compare_op additive)*
additive   ::= term (('+' | '-') term)*
term       ::= postfix (('*' | '/') postfix)*
postfix    ::= primary (call | '[' expression ']' | '.' NUMBER)*""")
    add_heading(doc, "4.4 函数归约点的语义动作", 2)
    add_body(doc, "Compiler 创建 Lexer、Parser 和 CodeGenerator，向 parse_program 传入 on_function 回调。每次 _parse_function_decl 返回 FunctionDecl 后，解析器立即调用回调；CodeGenerator.generate_function 为该函数建立 IRBuilder、作用域重命名器和循环标签栈，产生 IRFunction。最终 Program AST 与 IRFunction 列表同时得到。")
    add_code_block(doc, """ast = parser.parse_program(
    on_function=lambda function: ir_functions.append(
        code_generator.generate_function(function)
    )
)
SemanticAnalyzer().analyze(ast)
ir = IRProgram(functions=ir_functions)""")
    add_heading(doc, "4.5 声明、赋值和函数调用翻译", 2)
    add_body(doc, "声明产生 decl 四元式；带初始化声明在 decl 后生成 =；普通赋值先计算右侧，再根据左值种类生成 =、*=、[]= 或 .=。函数调用先从左到右计算实参并生成 param，再产生 call(callee, argc, result)。没有返回值的调用结果为占位符，语义阶段禁止其参与运算。")
    add_body(doc, "重影是本轮修复的重要问题。AST 允许同一作用域再次 let 同名变量，但若 IR 仍用源变量名，后一个绑定会覆盖前一个栈槽。CodeGenerator 现在为每次声明分配唯一内部名，例如 v1_value、v2_value，并在作用域栈中维护源名到内部名的映射；查找从栈顶向下进行，离开块时映射自动失效。")
    add_heading(doc, "4.6 控制流翻译与回填", 2)
    add_body(doc, "if/else-if/else 为每个条件产生 jz 到下一分支标签，并在执行完命中分支后 j 到公共结束标签。while 结构为 condition、end 两个标签；loop 为 begin、end；for 范围循环被降低为初始化、condition、body、increment、end。所有跳转目标在生成时已由 IRBuilder.new_label 分配，无需机器地址回填。")
    add_body(doc, "原实现中 for 循环的 continue 直接跳回条件标签，导致迭代变量不自增，综合程序会陷入死循环。本次改为在 loop_stack 中记录专用 continue_label，并让范围 for 的 continue 指向 increment 标签；自增完成后再跳回 condition。这一修复由专项四元式断言和综合可执行程序共同验证。")
    add_heading(doc, "4.7 块、if 与 loop 表达式", 2)
    add_body(doc, "BlockExpr 先生成内部语句，再返回 Block.result 的值；IfExpr 为各分支生成同一个结果临时变量，并要求存在 else 以保证值定义；LoopExpr 通过 break expression 把值写入结果临时变量后跳转到结束标签。语义分析保证多个可达 break 的值类型一致，普通 loop 语句则忽略返回值。")

    add_heading(doc, "五、静态语义与复合类型", 1, page_break=True)
    add_heading(doc, "5.1 函数表、作用域栈与初始化", 2)
    add_body(doc, "SemanticAnalyzer 先遍历 Program 收集所有函数签名，检查重名并记录形参类型和返回类型；随后逐函数压入函数作用域，把形参数标记为已初始化，再递归分析函数体。每进入一个 Block 压入新字典，离开时释放该层变量与借用状态。变量查找从栈顶向下，天然支持块级重影。")
    add_body(doc, "声明没有类型也没有初始化时，变量保持类型未知和未初始化；首次赋值可以推导类型，即使变量未标注 mut 也允许完成一次初始化。完成初始化后，不可变变量不得再次赋值。右值读取要求变量已声明、类型已知且已初始化。")
    add_heading(doc, "5.2 类型推导、函数调用和返回路径", 2)
    add_body(doc, "_type_of_expr 自底向上计算类型。算术运算要求两侧为 i32，比较运算要求类型兼容并产生内部 BoolType；if/while 条件接受比较结果或整数真值；范围端点和数组下标必须为 i32；数组字面量元素类型一致，元组按位置保存异构类型。调用检查函数存在、实参数量相等、各位置类型一致，并返回签名中的返回类型。")
    add_body(doc, "返回检查包含单条 return 和控制流路径两层。return value 必须与函数声明一致；声明 i32 返回的函数还必须保证所有可达路径返回值，或以类型一致的块尾表达式结束。if 语句只有在 then、所有 else-if 和 else 都返回时才视为完整返回，while/for 默认不能保证执行。missing_return_path 专项用例验证了这一规则。")
    add_heading(doc, "5.3 不可变性与借用模型", 2)
    add_body(doc, "变量符号记录 is_mut、immutable_borrows 和 mutable_borrow。&x 增加不可变借用计数，允许多个不可变借用并存；&mut x 仅允许作用于可变左值，且要求当前没有任何借用；可变借用存在时禁止直接读写原变量。不可变引用解引用后不可写，可变引用解引用后可写。引用变量离开词法作用域时释放相应借用。")
    add_body(doc, "该模型有意采用适合课程设计讲解的词法作用域生命周期，没有实现 Rust 编译器的非词法生命周期、移动语义和生命周期参数。限制被显式写入 README 和本报告，避免把教学检查器描述为完整 Rust 借用检查器。")
    add_heading(doc, "5.4 数组、元组与边界检查", 2)
    add_body(doc, "ArrayType 保存元素类型和定长，数组表达式必须非空且元素类型一致；显式数组类型还要求元素数量匹配。IndexExpr 的集合必须为数组且索引为 i32；常量索引在语义阶段直接验证 0 <= index < len。TupleType 保存元素类型列表，FieldExpr 的字段必须为整数字面量且在范围内。数组/元组元素的可写性继承根变量的可变性。")
    add_body(doc, "动态数组索引无法在编译期确定时，目标后端根据 FrameLayout 中传播的长度插入 cmp/jl/jge；越界跳转到函数专用 bounds_error 标签并执行 ud2。元组字段由语法限定为字面量，已在语义阶段静态检查，因此目标层只需按 field*8 访问。")
    add_heading(doc, "5.5 错误定位示例", 2)
    add_code_block(doc, """3:5 变量声明语句末尾缺少 ';'，当前符号: '}'
    }
    ^""")
    add_body(doc, "词法与语法错误包含行、列、源代码行和插入符。语义错误侧重规则说明，例如“不可变变量不能再次赋值”“可变借用不能与其他借用共存”“函数存在并非所有路径返回值”。这种分层信息便于在答辩时说明错误属于哪一编译阶段。")

    add_heading(doc, "六、中间代码与目标代码", 1, page_break=True)
    add_heading(doc, "6.1 四元式模型与指令集", 2)
    add_body(doc, "四元式统一为 Quad(op, arg1, arg2, result)，缺失操作数在文本中显示为下划线。IRBuilder 负责临时变量 t1、t2…和标签 L1、L2…的唯一编号；IRFunction 保存函数名、内部参数名与四元式列表；IRProgram 按函数组织输出。")
    add_table(doc, ["类别", "操作", "语义"], [
        ["声明/赋值", "decl, =", "分配逻辑位置；把 arg1 写入 result"],
        ["算术/比较", "+ - * / < <= > >= == !=", "计算两操作数并写临时结果"],
        ["控制流", "label, j, jz", "定义标签、无条件跳转、零条件跳转"],
        ["调用", "param, call, return", "准备实参、调用函数、返回值"],
        ["引用", "ref, ref_mut, deref, *=", "取地址、间接读取和间接写入"],
        ["复合类型", "[], []=, ., .=, len", "数组/元组读写与长度"],
    ], [1400, 2650, 4130], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])
    add_heading(doc, "6.2 典型翻译示例", 2)
    add_code_block(doc, """源程序：a = 1 + 2 * 3;

(*, 2, 3, t1)
(+, 1, t1, t2)
(=, t2, _, v1_a)""")
    add_body(doc, "乘法节点位于加法子树中，因此先产生 t1，再产生 t2，最后写入经过重影重命名的 v1_a。结构化控制流同样被显式标签和跳转线性化，这使目标后端无需理解 AST。")
    add_heading(doc, "6.3 IR 与汇编文件格式", 2)
    add_body(doc, "write_outputs 以源文件 stem 命名产物，在默认的“源文件所在目录/build”或 --output-dir 指定目录中写出 UTF-8 .ir 与 .s。IR 文件以 Function name(params): 开头并为每条四元式编号；汇编文件以 .intel_syntax noprefix 和 .text 开头，每个函数导出 .globl 符号。")
    add_heading(doc, "6.4 x86-64 栈帧与 Windows ABI", 2)
    add_body(doc, "AssemblyGenerator 首先扫描函数四元式建立 FrameLayout。每个参数、局部变量和临时值分配 8 字节栈槽；数组/元组临时对象另分配连续 backing 区域，并让逻辑变量保存首地址。帧大小向 16 字节对齐。函数序言 push rbp、mov rbp,rsp、sub rsp,frame_size，返回路径统一跳到 epilogue。")
    add_body(doc, "Windows x64 调用约定使用 rcx、rdx、r8、r9 传递前四个整数/地址实参，更多实参写到调用者栈；调用者始终预留 32 字节 shadow space 并保持 16 字节对齐。返回值位于 rax。教学类型 i32 在类型系统中仍是 32 位整数，但物理栈槽统一使用 QWORD，以同时容纳引用地址并简化后端。")
    add_heading(doc, "6.5 主要指令映射", 2)
    add_table(doc, ["IR", "x86-64 核心序列", "说明"], [
        ["+ / - / *", "mov + add/sub/imul", "结果写回目标栈槽"],
        ["/", "cqo + idiv", "有符号除法，商在 rax"],
        ["比较", "cmp + setcc + movzx", "规范化为 0/1"],
        ["j / jz", "jmp / test+je", "函数内标签加名前缀防冲突"],
        ["ref/ref_mut", "lea rax,[rbp-offset]", "引用保存真实栈地址"],
        ["deref/*=", "mov [rax]", "间接读写"],
        ["[]/[]=", "base + index*8", "已知长度时先做上下界检查"],
        ["call", "shadow space + 参数寄存器 + call", "返回值保存到结果槽"],
    ], [1100, 3000, 4080], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT], font_size=9)
    add_heading(doc, "6.6 汇编、链接与可执行输出", 2)
    add_code_block(doc, """python run.py examples/course_full.rs --no-tokens --no-ast --assemble
& examples/build/course_full.exe
$LASTEXITCODE
# 42""")
    add_body(doc, "assemble 使用 subprocess.run([gcc, asm_path, -o, executable_path], check=True)。综合样例的 main 无参数并返回 i32，最终计算值为 42；目标程序执行后 PowerShell 退出码为 42，证明生成的控制流、调用、复合类型和引用路径在机器层贯通。")
    add_heading(doc, "6.7 目标后端边界", 2)
    add_body(doc, "当前后端未实现优化、调试信息、浮点数、字符串、结构体、堆分配和完整 Rust 所有权系统；仅面向 Windows x86-64 与 GNU 汇编器。动态数组长度传播只覆盖本课程 IR 中可追踪的声明与赋值。对课程范围外的四元式操作，后端抛出 TargetCodeError，而不是静默生成错误指令。")

    add_heading(doc, "七、程序实现与使用", 1, page_break=True)
    add_heading(doc, "7.1 项目目录", 2)
    add_code_block(doc, """analyzer/
├─ gui.py                  蓝白渐变首页与可视化编译工作台
├─ run.py                  Python 命令行入口
├─ run_regression.py       编译器核心 44 组回归
├─ run_gui_tests.py        GUI 结果适配、错误恢复与 GCC 运行测试
├─ build_release.ps1       GUI/CLI 单文件发布脚本
├─ assets/                 PNG/ICO 与 Windows 版本资源
├─ dist/
│  ├─ rust_like_compiler.exe      无控制台 GUI
│  └─ rust_like_compiler_cli.exe  独立 CLI
├─ examples/course_full.rs 综合可执行样例
└─ src/                    词法、语法、语义、IR 与目标后端""")
    add_heading(doc, "7.2 关键类与函数索引", 2)
    add_table(doc, ["符号", "文件", "职责"], [
        ["Lexer.next_token", "src/lexer.py", "按需扫描一个 Token"],
        ["Parser.parse_program", "src/parser.py", "函数串解析与 on_function 回调"],
        ["Parser._ensure_token", "src/parser.py", "请求 Token 并维护前看缓存"],
        ["SemanticAnalyzer.analyze", "src/semantic.py", "程序级签名与逐函数语义检查"],
        ["CodeGenerator.generate_function", "src/codegen.py", "FunctionDecl 到 IRFunction"],
        ["AssemblyGenerator.generate", "src/target.py", "IRProgram 到 x86-64"],
        ["Compiler.compile", "src/compiler.py", "统一编译协调器"],
        ["CompilerDemoApp", "gui.py", "首页、工作台、文件操作与窗口生命周期"],
        ["CompilerWorkbench.compile_now", "gui.py", "内存编译并原子更新五类结果"],
        ["run_file", "src/main.py", "CLI 展示、文件输出、GCC 与错误返回"],
    ], [2500, 1800, 3880], [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])
    add_heading(doc, "7.3 命令行参数", 2)
    add_table(doc, ["参数", "作用"], [
        ["input_file", "输入类 Rust 源文件；缺省为 examples/course_full.rs"],
        ["--no-tokens", "不打印 Token 列表"],
        ["--no-ast", "不打印 AST JSON 和树"],
        ["--no-semantic", "跳过语义检查，仅用于调试"],
        ["--no-ir", "不在终端打印四元式"],
        ["--show-asm", "在终端打印 x86-64 汇编"],
        ["--output-dir DIR", "指定 .ir/.s/.exe 输出目录"],
        ["--no-write", "不写文件，不能与 --assemble 同用"],
        ["--assemble", "调用 GCC 生成可执行程序"],
    ], [2200, 5980], [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])
    add_heading(doc, "7.4 独立程序打包", 2)
    add_body(doc, "build_release.ps1 使用 64 位 Python 3.11 与 PyInstaller 6.15 构建两个单文件程序。dist/rust_like_compiler.exe 使用 Windows GUI Subsystem 2，双击后没有黑色控制台并保持事件循环；dist/rust_like_compiler_cli.exe 使用 Console Subsystem 3，保留 python run.py 的全部参数。GUI 内置 16 个 .rs 示例、Tk 运行时和多尺寸应用图标，生成 IR/汇编不依赖 GCC，只有“编译并运行”功能需要 GCC。最终 GUI EXE 的 SHA-256 为 86D21D6BCBBE95252F3C9A2BA16070913A88E88CEF898F526ECE483231C5E274。")

    add_heading(doc, "7.5 可视化演示器首页与工作台", 2, page_break=True)
    add_body(doc, "可视化层直接调用 Compiler.compile(source)，不解析命令行文本，也不在实时分析阶段写临时文件。程序启动后先显示蓝白渐变首页，提供综合功能、基础语法和错误定位三个入口；进入工作台后，左侧为带行号和语法高亮的源码编辑器，右侧用 Token、AST、IR、x86-64 和诊断页展示编译结果。用户既可以载入内置示例，也可以打开文件或直接输入自己的源程序。")
    add_figure(doc, GUI_HOME_PNG, "图 7-1 蓝白渐变首页与三类演示入口")
    add_body(doc, "“实时分析”默认开启。文本变化后先将上一版结果标为失效，停止输入约 0.5 秒后重新编译；成功时五个统计卡片同步显示 262 个可见 Token、3 个函数、98 条四元式、语义通过和 286 行汇编。左右分栏可拖动，1286×688 窗口及 150% 缩放下均完成截图复核。")
    add_figure(doc, GUI_IR_PNG, "图 7-2 综合示例及动态四元式 IR 结果")

    add_heading(doc, "7.6 目标代码与错误诊断展示", 2, page_break=True)
    add_body(doc, "目标代码页直接显示 AssemblyGenerator 产生的 GNU Intel x86-64 汇编，可水平、垂直滚动并复制或导出。界面顶部同时保留阶段统计，使演示时可以从函数级四元式切换到真实栈帧、算术、跳转与调用指令，而不需要打开外部编辑器。")
    add_figure(doc, GUI_ASM_PNG, "图 7-3 综合示例生成的 x86-64 目标汇编")
    add_body(doc, "当编译失败时，界面根据 LexerError、ParserError、CodegenError、SemanticError 或 TargetCodeError 标记失败阶段；词法和语法错误还会解析行列并高亮源码行。所有旧 Token、AST、IR 和汇编页立即清空，避免把上一版成功结果误认为本次输出。图 7-4 中缺少分号的示例在语法分析阶段被拒绝，第 3 行同时以红色背景定位。")
    add_figure(doc, GUI_ERROR_PNG, "图 7-4 语法错误的阶段状态、行列信息与源码高亮")

    add_heading(doc, "7.7 汇编运行与退出码", 2, page_break=True)
    add_body(doc, "点击“编译并运行”后，演示器在后台临时目录写入本次汇编，调用 GCC 链接并执行目标程序，再把标准输出、标准错误和退出码留在诊断页，全程不弹出一闪而过的控制台。综合示例无打印语句，因而标准输出和标准错误均为空，退出码 42 即为最终计算结果。运行期间重复按 F6 不会启动并发任务；若源码已修改或窗口关闭，旧运行结果不会覆盖新状态，活动目标进程也会被终止。")
    add_figure(doc, GUI_RUN_PNG, "图 7-5 综合示例经 GCC 汇编运行后的退出码 42")

    add_heading(doc, "八、测试设计与实验结果", 1, page_break=True)
    add_heading(doc, "8.1 分层测试策略", 2)
    add_body(doc, "测试不只统计样例文件，而是按编译阶段组织：文件正例/负例验证整体行为；词法边界验证关键字和最长匹配；AST 断言验证文法结构；IR 断言验证控制流和表达式翻译；内存语义用例验证不可变性、借用、越界和返回路径；管线专项检查按需 Lexer 与函数回调；GUI 专项检查结果适配、示例发现、旧状态清理、自动恢复和真实运行；最后由 GCC 汇编执行综合程序。")
    add_table(doc, ["层次", "代表检查", "预期"], [
        ["文件正例", "minimum、v1_ir、v2_compare、course_full", "完整通过"],
        ["文件负例", "err_lex、err_parse、*_error", "在正确阶段拒绝"],
        ["词法", "if123、if=123、->、..", "边界与最长匹配正确"],
        ["AST", "p1/p2/p3 节点", "节点类型和层次正确"],
        ["IR", "if/while/for/call/if expr/loop expr", "标签、临时值和跳转正确"],
        ["语义", "mut、借用、数组/元组、return", "合法放行、非法拦截"],
        ["管线", "lexer_on_demand_and_function_codegen_hook", "未预扫描且回调次数正确"],
        ["目标", "assemble_and_execute", "GCC 成功且退出码 42"],
        ["GUI", "结果模型、错误恢复、动态编译、compile_and_run", "10 项通过且退出码 42"],
    ], [1350, 4450, 2380], [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT], font_size=9)
    add_heading(doc, "8.2 44 组回归结果", 2)
    add_body(doc, "本轮实际执行 python run_regression.py，所有检查均输出 [PASS]，末尾为 Regression passed。44 组由 12 个正确源文件、4 个错误源文件、3 个词法检查、3 个 AST 检查、6 个 IR 检查、14 个语义检查、1 个管线检查和 1 个目标执行检查组成。随后运行 run_gui_tests.py，10 项界面适配与交互检查全部通过，其中 compile_and_run_exit_42 会真实创建工作台、调用 GCC 并核对退出码。")
    add_table(doc, ["类别", "数量", "结果"], [
        ["正确源文件", "12", "12/12 通过"],
        ["错误源文件", "4", "4/4 被正确拒绝"],
        ["词法专项", "3", "3/3 通过"],
        ["AST 专项", "3", "3/3 通过"],
        ["IR 专项", "6", "6/6 通过"],
        ["语义专项", "14", "14/14 通过"],
        ["按需管线", "1", "1/1 通过"],
        ["汇编执行", "1", "1/1 通过，退出码 42"],
        ["合计", "44", "44/44 通过"],
        ["GUI 专项（另计）", "10", "10/10 通过，界面运行退出码 42"],
    ], [3000, 1200, 3980], [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER])
    add_heading(doc, "8.3 综合样例覆盖", 2)
    add_body(doc, "course_full.rs 定义 add、classify 和 main 三个函数，覆盖多参数调用、函数尾表达式、if/else-if/else、范围 for 与 continue、数组声明/初始化/下标、元组与字段写入、可变引用和解引用、while、loop 表达式、if 表达式、块表达式以及嵌套算术。最终表达式调用 add，理论值和机器执行值均为 42。")
    add_heading(doc, "8.4 关键缺陷的回归证据", 2)
    add_list(doc, [
        "for continue：IR 必须先跳到自增标签，再返回条件标签。",
        "重影：同名声明必须生成不同 vN_name，目标栈槽不再覆盖。",
        "借用互斥：存在不可变借用时拒绝 &mut；可变借用期间拒绝直接访问原变量。",
        "不可变首次初始化：let a:i32; a=1 合法，之后 a=2 非法。",
        "返回路径：声明 i32 的函数若存在可达无返回路径必须拒绝。",
        "数组边界：常量越界在语义阶段拒绝，动态越界在目标层执行 ud2。",
    ], bullet_id)
    add_heading(doc, "8.5 源码入口与打包程序交叉验证", 2)
    add_body(doc, "同一个 course_full.rs 通过 Python 源码入口、GUI 内存入口和 dist/rust_like_compiler_cli.exe 编译，三条路径均得到 262 个可见 Token、3 个函数、98 条四元式和 286 行汇编，目标程序退出码均为 42。打包版 GUI 的 --smoke-test 返回 0，无参数启动 5 秒后进程仍保持运行；PE 头核对为 Subsystem 2，归档中包含 16 个示例和 PNG/ICO 资源。交叉验证降低了“源码可运行但打包缺模块”或“主程序仍是旧控制台版本”的风险。")
    add_heading(doc, "8.6 测试局限", 2)
    add_body(doc, "回归覆盖课程文法、GUI 主要状态和已知边界，但不等同形式证明。未覆盖随机生成程序、约两万个函数以上的超大输入性能、所有 GCC 版本、极低分辨率、Linux System V ABI 或真正 Rust 生命周期。后续可引入基于文法的属性测试、IR 解释器对照、差分执行、后台编译任务和控制流图覆盖率。")

    add_heading(doc, "九、问题解决与 AI 辅助历程", 1, page_break=True)
    add_heading(doc, "9.1 从分离流水线改为 Parser 主控", 2)
    add_body(doc, "旧流程先 Lexer.tokenize 得到完整列表，再构造 Parser，虽然模块清楚，但不符合附件“词法分析作为子程序，需要时由语法分析调用”的硬约束。改造时保留 tokenize 作为调试兼容接口，正式 Compiler 传入 Lexer；Parser 通过 _ensure_token 惰性填充缓存。专项测试使用计数 Lexer 证明构造 Parser 后不会立即扫描全文件，并核对函数回调次数。")
    add_heading(doc, "9.2 控制流与重影缺陷", 2)
    add_body(doc, "AI 辅助审查首先指出 for 的 continue 目标不能与 while 相同。根据降低后的控制流逐条推演，确认原 IR 会跳过自增，于是新增 increment 标签。进一步检查目标栈布局时发现 AST/语义允许重影，而 IR 名称仍复用源变量名，造成后绑定覆盖前栈槽；通过作用域重命名器分配唯一内部名解决。两个缺陷都增加了回归断言，而不是只修改实现。")
    add_heading(doc, "9.3 借用、返回与边界规则补强", 2)
    add_body(doc, "初版语义分析只检查部分 mut 规则，缺少多不可变借用、可变借用冲突、借用释放、不可变首次初始化和完整返回路径。根据附件 6.x 语义说明和实际 AST，补充符号状态与控制流返回判断。数组常量边界在语义阶段处理，动态边界在汇编后端处理，形成编译期与运行期分工。")
    add_heading(doc, "9.4 目标后端中的工程问题", 2)
    add_body(doc, "目标后端需要同时考虑教学类型、指针宽度、栈对齐、shadow space、参数位置和复合对象存储。为降低复杂度，物理槽统一为 64 位，数组/元组变量保存 backing 首地址；函数标签增加函数名前缀；所有 return 汇聚到统一尾声。遇到未知 IR 操作时显式报错，避免生成表面可汇编但语义错误的代码。")
    add_heading(doc, "9.5 AI 工具使用披露", 2)
    add_body(doc, "本次课程设计于 2026 年 7 月 22—26 日使用 OpenAI Codex 辅助读取课程要求、梳理旧代码差距、提出实现候选、补充测试、重写 README、构建可视化演示器，并生成和增补报告与 PPT。AI 参与了代码建议、界面设计和文档组织，因此本项目不把这些环节描述为完全人工完成。")
    add_body(doc, "对 AI 产出采用可复核审查：第一，所有实现必须落到现有数据模型，不允许为展示效果虚构功能；第二，运行 compileall、44 组核心回归和 10 项 GUI 检查；第三，用 GCC 生成并实际执行目标程序；第四，使用源码入口与打包 EXE 交叉验证；第五，对首页、IR、汇编、错误和退出码逐屏截图核对；第六，Word/PPT 均逐页渲染检查。")
    add_heading(doc, "9.6 对 AI 辅助的反思", 2)
    add_body(doc, "AI 的优势是能快速跨越文法、IR、ABI、测试和文档多个层次，尤其擅长发现接口间的不一致；风险是容易把“生成了代码”误当成“满足了语义”，或给出超出课程范围的复杂设计。本项目最重要的经验不是接受更多生成内容，而是把每项建议转换为可观察的不变量：扫描次数、回调时机、四元式序列、栈槽唯一性、退出码和错误阶段。只有这些证据成立，AI 建议才被保留。")

    add_heading(doc, "十、总结与展望", 1, page_break=True)
    add_heading(doc, "10.1 工作总结", 2)
    add_body(doc, "本项目完成了从类 Rust 源程序到 Token、AST、语义校验、四元式、x86-64 汇编和 Windows 可执行程序的完整链路。与旧作业相比，最核心的变化是 Parser 按需驱动 Lexer，并在函数归约点生成 IR；同时新增目标后端、文件输出、蓝白渐变可视化演示器、独立 GUI/CLI 程序和端到端执行验证。")
    add_body(doc, "规则层面覆盖附件 0.1–9.3，包含重影、控制流表达式、引用借用、数组元组等扩展；质量层面修复了 continue、自增、重影栈槽、借用互斥、首次初始化、返回路径和越界等问题。44 组核心回归和 10 项 GUI 检查全部通过，综合程序退出码 42；报告中的五张界面截图进一步给出了可观察、可复核的实验过程证据。")
    add_heading(doc, "10.2 后续工作", 2)
    add_list(doc, [
        "构建控制流图和 SSA，增加常量折叠、死代码消除和寄存器分配。",
        "把借用检查扩展为非词法生命周期，并加入移动语义和所有权转移。",
        "支持更多基础类型、字符串、结构体和堆对象。",
        "增加 Linux System V ABI 后端和跨平台工具链检测。",
        "引入文法随机生成、IR 解释器差分测试和覆盖率统计。",
        "把错误恢复加入 Parser，使一次编译报告多个独立错误。",
        "把实时编译迁移到带版本号的后台任务，进一步提升超大输入下的界面响应。",
    ], bullet_id)
    add_heading(doc, "10.3 设计体会", 2)
    add_body(doc, "课程设计使抽象概念转化为可执行约束：最长匹配体现在 Token 边界，左递归消除体现在循环式解析，语法制导翻译体现在 FunctionDecl 回调，符号表体现在作用域栈，控制流体现在标签与跳转，调用约定最终体现在真实寄存器与栈。只有当目标程序运行并给出预期退出码时，这些阶段才真正构成一条编译链。")

    add_heading(doc, "参考资料", 1, page_break=True)
    references = [
        "[1] Aho A V, Lam M S, Sethi R, Ullman J D. Compilers: Principles, Techniques, and Tools (2nd Edition). Addison-Wesley, 2006.",
        "[2] Appel A W. Modern Compiler Implementation in C. Cambridge University Press, 1998.",
        "[3] The Rust Project Developers. The Rust Reference. https://doc.rust-lang.org/reference/.",
        "[4] Klabnik S, Nichols C. The Rust Programming Language (2nd Edition). No Starch Press, 2023.",
        "[5] Microsoft. x64 calling convention. https://learn.microsoft.com/cpp/build/x64-calling-convention.",
        "[6] Free Software Foundation. Using the GNU Compiler Collection. https://gcc.gnu.org/onlinedocs/.",
        "[7] PyInstaller Development Team. PyInstaller Manual. https://pyinstaller.org/en/stable/.",
        "[8] 同济大学计算机系.《编译原理课程设计 2026（类 Rust 编译器实现）》课程附件.",
    ]
    for ref in references:
        add_body(doc, ref, indent=False)

    add_heading(doc, "附录 A：核心文法摘要", 1, page_break=True)
    add_code_block(doc, """Program      ::= FunctionDecl* '#'? EOF
FunctionDecl ::= 'fn' ID '(' Params? ')' ('->' Type)? Block
Type         ::= 'i32' | '&' 'mut'? Type
               | '[' Type ';' NUM ']'
               | '(' ')' | '(' Type ',' (Type (',' Type)*)? ')'
Statement    ::= ';' | Let | Assign | Return | If | While | For | Loop
               | 'break' Expression? ';' | 'continue' ';' | Expression ';'
Expression   ::= comparison
comparison   ::= additive (compare_op additive)*
additive     ::= term (('+'|'-') term)*
term         ::= factor (('*'|'/') factor)*
factor       ::= NUM | ID | Call | Borrow | Deref | Array | Tuple
               | BlockExpr | IfExpr | LoopExpr | factor '[' Expression ']'
               | factor '.' NUM""")
    add_body(doc, "完整实现以 src/parser.py 为准。附件中的个别排版疑点（7.5 未定义、元组示例分隔符等）按正文语义意图和测试一致性处理。")

    add_heading(doc, "附录 B：复现实验命令", 1, page_break=True)
    add_code_block(doc, """cd analyzer
python -m compileall -q src gui.py run.py run_gui_tests.py run_regression.py
python run_regression.py
python run_gui_tests.py
python gui.py --smoke-test

python run.py examples/course_full.rs --no-tokens --no-ast --assemble
& examples/build/course_full.exe
$LASTEXITCODE

dist/rust_like_compiler_cli.exe examples/course_full.rs `
  --no-tokens --no-ast --no-ir --output-dir build/exe-check --assemble""")
    add_body(doc, "双击 dist/rust_like_compiler.exe 可进入可视化首页；命令行自动化使用 rust_like_compiler_cli.exe。若未安装 GCC，核心回归的目标执行项与 GUI 运行项会显示 [SKIP]，其余前端与可视化编译检查仍可运行；申请优秀档验收时应在具备 GCC 的环境中完成完整目标代码验证。")

    doc.core_properties.title = "类 Rust 一遍式编译器课程设计实验报告"
    doc.core_properties.subject = "编译原理课程设计：一遍式编译、语法制导 IR 与 x86-64 目标代码"
    doc.core_properties.author = "课程设计项目组"
    doc.core_properties.keywords = "类Rust, 一遍编译, 四元式, x86-64, 编译原理"
    image_alt_texts = (
        "同济大学校徽",
        "一遍式类 Rust 编译器总体数据流：Parser 按需调用 Lexer，函数归约时生成 IR，经语义检查、x86-64 后端与 GCC 形成可执行程序",
        "类 Rust 一遍式编译器蓝白渐变首页，包含综合功能、基础语法和错误定位三个演示入口",
        "综合示例可视化工作台：左侧显示类 Rust 源码，右侧显示 98 条四元式中间代码和阶段统计",
        "综合示例可视化工作台的 x86-64 目标汇编页面",
        "语法错误示例：第 3 行红色高亮，语法阶段失败并显示行列和插入符诊断",
        "综合示例经 GCC 汇编并运行完成，诊断页面显示退出码 42，标准输出和标准错误为空",
    )
    for doc_pr, alt_text in zip(doc.element.iter(qn("wp:docPr")), image_alt_texts):
        doc_pr.set("descr", alt_text)
        doc_pr.set("title", alt_text)
    settings = doc.settings.element
    update_fields = settings.find(qn("w:updateFields"))
    if update_fields is None:
        update_fields = OxmlElement("w:updateFields")
        settings.append(update_fields)
    update_fields.set(qn("w:val"), "true")
    doc.save(OUTPUT)
    print(OUTPUT)


if __name__ == "__main__":
    build()
