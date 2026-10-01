from __future__ import annotations

import json
import posixpath
import sys
import zipfile
from pathlib import PurePosixPath

from lxml import etree


P = "http://schemas.openxmlformats.org/presentationml/2006/main"
A = "http://schemas.openxmlformats.org/drawingml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG = "http://schemas.openxmlformats.org/package/2006/relationships"
NS = {"p": P, "a": A, "r": R, "pr": PKG}


def resolve(part: str, target: str) -> str:
    return posixpath.normpath(posixpath.join(posixpath.dirname(part), target))


def rels_path(part: str) -> str:
    p = PurePosixPath(part)
    return str(p.parent / "_rels" / f"{p.name}.rels")


def relationship_map(z: zipfile.ZipFile, part: str):
    rp = rels_path(part)
    if rp not in z.namelist():
        return {}
    root = etree.fromstring(z.read(rp))
    return {
        el.get("Id"): {"type": el.get("Type"), "target": resolve(part, el.get("Target"))}
        for el in root.findall("pr:Relationship", NS)
    }


def paragraphs(root):
    result = []
    for para in root.xpath(".//a:p", namespaces=NS):
        text = "".join(para.xpath(".//a:t/text()", namespaces=NS)).strip()
        if text:
            ppr = para.find("a:pPr", NS)
            result.append({
                "text": text,
                "level": int(ppr.get("lvl", "0")) if ppr is not None else 0,
            })
    return result


def main(pptx: str, out: str):
    with zipfile.ZipFile(pptx) as z:
        pres_part = "ppt/presentation.xml"
        pres = etree.fromstring(z.read(pres_part))
        rels = relationship_map(z, pres_part)
        slide_parts = []
        for sld_id in pres.xpath(".//p:sldIdLst/p:sldId", namespaces=NS):
            rid = sld_id.get(f"{{{R}}}id")
            slide_parts.append(rels[rid]["target"])

        slides = []
        for i, part in enumerate(slide_parts, 1):
            root = etree.fromstring(z.read(part))
            slide_rels = relationship_map(z, part)
            note_parts = [v["target"] for v in slide_rels.values() if v["type"].endswith("/notesSlide")]
            notes = []
            for n_part in note_parts:
                if n_part in z.namelist():
                    n_root = etree.fromstring(z.read(n_part))
                    notes.extend(paragraphs(n_root))
            slides.append({
                "slide": i,
                "part": part,
                "paragraphs": paragraphs(root),
                "notes": notes,
                "all_text": "\n".join(p["text"] for p in paragraphs(root)),
            })
    with open(out, "w", encoding="utf-8") as f:
        json.dump({"pptx": pptx, "slide_count": len(slides), "slides": slides}, f, ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
