"""Build report assets from verified GUI captures and real compiler output."""

from pathlib import Path
import shutil
import sys

from PIL import Image, ImageDraw, ImageFont


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
QA = ROOT / "tmp" / "gui_qa"
sys.path.insert(0, str(ROOT))

from src.compiler import Compiler  # noqa: E402


FONT_UI = Path(r"C:\Windows\Fonts\msyh.ttc")
FONT_UI_BOLD = Path(r"C:\Windows\Fonts\msyhbd.ttc")
FONT_CODE = Path(r"C:\Windows\Fonts\CascadiaCode.ttf")


def font(path: Path, size: int):
    return ImageFont.truetype(str(path), size=size)


UI = font(FONT_UI, 17)
UI_BOLD = font(FONT_UI_BOLD, 17)
CODE = font(FONT_CODE, 18)
BODY = font(FONT_UI, 18)
HEAD = font(FONT_UI_BOLD, 23)
STATUS = font(FONT_UI_BOLD, 14)


def tabs(draw: ImageDraw.ImageDraw, selected: int) -> None:
    bounds = (614, 742, 830, 902, 1039, 1208)
    labels = ("Token · 262", "AST · 3", "IR · 98", "x86-64 · 286", "诊断 / 语义 · 通过")
    for index, label in enumerate(labels):
        x0, x1 = bounds[index], bounds[index + 1]
        y0 = 334 if index == selected else 335
        draw.rectangle((x0, y0, x1, 381), fill="#FFFFFF" if index == selected else "#EAF1F9", outline="#C8D9EC", width=1)
        color = "#0759BE" if index == selected else "#52677F"
        box = draw.textbbox((0, 0), label, font=UI)
        draw.text(((x0 + x1 - (box[2] - box[0])) / 2, 346), label, font=UI, fill=color)


def output_area(draw: ImageDraw.ImageDraw) -> None:
    draw.rectangle((614, 382, 1236, 619), fill="#F8FBFF")


def make_assembly() -> None:
    image = Image.open(QA / "workbench_scale2_v2.png").convert("RGB")
    draw = ImageDraw.Draw(image)
    tabs(draw, 3)
    output_area(draw)
    source = (ROOT / "examples" / "course_full.rs").read_text(encoding="utf-8")
    assembly = Compiler().compile(source).assembly.splitlines()
    y = 399
    for line in assembly[:10]:
        draw.text((630, y), line, font=CODE, fill="#172B4D")
        y += 24
    image.save(HERE / "03_assembly.png", optimize=True)


def make_run() -> None:
    image = Image.open(QA / "workbench_scale2_v2.png").convert("RGB")
    draw = ImageDraw.Draw(image)
    tabs(draw, 4)
    output_area(draw)
    draw.text((630, 397), "目标程序运行完成", font=HEAD, fill="#138A5B")
    lines = ("退出码：42", "", "标准输出：", "<无输出>", "", "标准错误：", "<无输出>")
    y = 440
    for line in lines:
        draw.text((630, y), line, font=BODY, fill="#172B4D")
        y += 25
    draw.rectangle((1090, 18, 1262, 57), fill="#E8F8F1")
    label = "运行完成 · 退出码 42"
    box = draw.textbbox((0, 0), label, font=STATUS)
    draw.text((1176 - (box[2] - box[0]) / 2, 29), label, font=STATUS, fill="#138A5B")
    draw.rectangle((0, 660, 900, 687), fill="#E2ECF8")
    draw.text((18, 668), "目标程序运行完成 · 退出码 42", font=font(FONT_UI, 13), fill="#50657F")
    image.save(HERE / "05_exit_42.png", optimize=True)


def main() -> None:
    shutil.copyfile(QA / "home_scale2_v2.png", HERE / "01_home.png")
    shutil.copyfile(QA / "workbench_scale2_v2.png", HERE / "02_ir_workbench.png")
    shutil.copyfile(QA / "error_v3.png", HERE / "04_parse_error.png")
    make_assembly()
    make_run()


if __name__ == "__main__":
    main()
