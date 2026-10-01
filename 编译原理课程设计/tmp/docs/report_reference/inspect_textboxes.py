from __future__ import annotations

import json
import sys
import zipfile
from collections import Counter

from lxml import etree


NS = {
    "w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
    "v": "urn:schemas-microsoft-com:vml",
}
W = "{%s}" % NS["w"]


def attr(el, local):
    return None if el is None else el.get(W + local)


def run_format(run):
    rpr = run.find("w:rPr", NS)
    fonts = rpr.find("w:rFonts", NS) if rpr is not None else None
    sz = rpr.find("w:sz", NS) if rpr is not None else None
    return {
        "ascii": attr(fonts, "ascii"),
        "eastAsia": attr(fonts, "eastAsia"),
        "size_pt": None if sz is None or attr(sz, "val") is None else int(attr(sz, "val")) / 2,
        "bold": rpr.find("w:b", NS) is not None if rpr is not None else None,
        "italic": rpr.find("w:i", NS) is not None if rpr is not None else None,
    }


def main(path, out=None):
    with zipfile.ZipFile(path) as z:
        root = etree.fromstring(z.read("word/document.xml"))
    boxes = []
    sigs = Counter()
    for i, tx in enumerate(root.xpath(".//w:txbxContent", namespaces=NS), 1):
        shape = tx.getparent()
        while shape is not None and etree.QName(shape).localname not in {"shape", "rect", "roundrect"}:
            shape = shape.getparent()
        paras = []
        for p in tx.xpath(".//w:p", namespaces=NS):
            text = "".join(p.xpath(".//w:t/text()", namespaces=NS))
            pstyle = p.find("w:pPr/w:pStyle", NS)
            formats = []
            for r in p.xpath("./w:r", namespaces=NS):
                if "".join(r.xpath(".//w:t/text()", namespaces=NS)).strip():
                    fmt = run_format(r)
                    formats.append(fmt)
                    sigs[json.dumps(fmt, ensure_ascii=False, sort_keys=True)] += len("".join(r.xpath(".//w:t/text()", namespaces=NS)))
            if text.strip():
                paras.append({"text": text, "style": attr(pstyle, "val"), "formats": formats})
        boxes.append({
            "index": i,
            "shape_style": None if shape is None else shape.get("style"),
            "stroke": None if shape is None else shape.get("stroked"),
            "stroke_color": None if shape is None else shape.get("strokecolor"),
            "fill": None if shape is None else shape.get("fillcolor"),
            "paragraphs": paras,
        })
    payload = json.dumps({"count": len(boxes), "weighted_run_formats": sigs.most_common(), "boxes": boxes}, ensure_ascii=False, indent=2)
    if out:
        with open(out, "w", encoding="utf-8") as f:
            f.write(payload)
    else:
        print(payload)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
