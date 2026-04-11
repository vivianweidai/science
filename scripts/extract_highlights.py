#!/usr/bin/env python3
"""Extract yellow-highlighted rows from curriculum NOTES PDFs.

For each PDF, walks every page, runs PyMuPDF's `find_tables()`, detects
yellow cell fills, and emits JSON describing which rows are highlighted
for each table:

    {
      "divisors": [
        {"row": 1, "description": "Euclidean"},
        {"row": 2, "description": "Bezout"}
      ],
      "factorization": [...],
      ...
    }

`row` is 0-indexed over data rows only (the grey header row is excluded).
`description` is the cell text in the rightmost column (used to match
against the markdown tables which all have a plain-text description).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import pymupdf


def is_yellow(rgb):
    if rgb is None:
        return False
    r, g, b = rgb
    return r > 0.85 and g > 0.85 and b < 0.35


def page_yellow_rects(page) -> list[tuple[float, float, float, float]]:
    rects = []
    for d in page.get_drawings():
        fill = d.get("fill")
        if not fill or not is_yellow(fill):
            continue
        for item in d["items"]:
            if item[0] == "re":
                r = item[1]
                rects.append((r.x0, r.y0, r.x1, r.y1))
    return rects


def rect_overlap_area(a, b):
    """Positive overlap area, zero if rects only touch or don't intersect."""
    if a is None or b is None:
        return 0.0
    dx = min(a[2], b[2]) - max(a[0], b[0])
    dy = min(a[3], b[3]) - max(a[1], b[1])
    if dx <= 0 or dy <= 0:
        return 0.0
    return dx * dy


def cell_is_yellow(cell_rect, yellows, min_fraction=0.5):
    if cell_rect is None:
        return False
    cw = cell_rect[2] - cell_rect[0]
    ch = cell_rect[3] - cell_rect[1]
    if cw <= 0 or ch <= 0:
        return False
    cell_area = cw * ch
    covered = 0.0
    for y in yellows:
        covered += rect_overlap_area(cell_rect, y)
    return covered / cell_area >= min_fraction


def cell_to_rect(cell):
    if cell is None:
        return None
    return (cell[0], cell[1], cell[2], cell[3])


def page_headers(page) -> tuple[str, str]:
    """Return (section, topic) from the top of the page.

    The layout puts SECTION (e.g. "NUMBER THEORY") on the right edge of the
    header strip and TOPIC (e.g. "DIVISORS") a few lines below. Topic is the
    first UPPERCASE block-level text after the section line.
    """
    top_text = page.get_text("text", clip=(0, 0, page.rect.width, 130))
    lines = [ln.strip() for ln in top_text.splitlines() if ln.strip()]
    section = ""
    topic = ""
    for ln in lines:
        if ln.isupper() and len(ln) >= 2:
            if not section:
                section = ln
            elif not topic:
                topic = ln
                break
    return section.title(), topic.title()


def extract_from_pdf(pdf_path: Path) -> dict:
    """Return nested dict: section -> topic -> table -> [highlighted descriptions]."""
    doc = pymupdf.open(pdf_path)
    result: dict = {}

    for page_num, page in enumerate(doc, start=1):
        yellows = page_yellow_rects(page)
        if not yellows:
            continue
        section, topic = page_headers(page)
        if not section or not topic:
            continue
        tables = page.find_tables()
        for t in tables:
            data = t.extract()
            if not data:
                continue
            # First row is the gray header containing the table name.
            header_cell = data[0][0] if data[0] else None
            if not header_cell:
                continue
            table_name = str(header_cell).strip()
            if not table_name:
                continue

            highlighted_rows = []
            # Iterate data rows (skip header at index 0).
            row_objs = list(t.rows)
            for data_idx, (row_obj, row_data) in enumerate(zip(row_objs[1:], data[1:])):
                # The first column holds section names that span multiple
                # rows, so only inspect the middle (formula) and right
                # (description) columns. The description column always has
                # its own row-sized cell.
                cell_rects = [cell_to_rect(c) for c in row_obj.cells[1:]]
                cell_rects = [cr for cr in cell_rects if cr is not None]
                if not cell_rects:
                    continue
                is_highlighted = any(
                    cell_is_yellow(cr, yellows) for cr in cell_rects
                )
                if not is_highlighted:
                    continue
                # Rightmost non-None cell text is the description.
                description = ""
                for v in reversed(row_data):
                    if v:
                        description = str(v).strip()
                        break
                highlighted_rows.append({
                    "row": data_idx,
                    "description": description,
                    "page": page_num,
                })

            if highlighted_rows:
                result.setdefault(section, {}) \
                      .setdefault(topic, {}) \
                      .setdefault(table_name, []) \
                      .extend(highlighted_rows)

    return result


def main():
    if len(sys.argv) < 2:
        # Default: extract all six and write archives/curriculum_highlights.json
        root = Path(__file__).resolve().parent.parent
        subjects = ["mathematics", "computing", "physics",
                    "chemistry", "biology", "astronomy"]
        all_data = {}
        for s in subjects:
            pdf = root / "archives" / "NOTES" / f"{s}.pdf"
            if not pdf.exists():
                continue
            print(f"Extracting {s}.pdf...", file=sys.stderr)
            all_data[s] = extract_from_pdf(pdf)
        out = root / "archives" / "curriculum_highlights.json"
        out.write_text(json.dumps(all_data, indent=2) + "\n")
        print(f"Wrote {out}", file=sys.stderr)
    else:
        data = extract_from_pdf(Path(sys.argv[1]))
        print(json.dumps(data, indent=2))


if __name__ == "__main__":
    main()
