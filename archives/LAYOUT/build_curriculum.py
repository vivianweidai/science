#!/usr/bin/env python3
"""Regenerate archives/CONTENT/curriculum.json — the single source of
truth for the curriculum widget.

This script replaces three older scripts in one pass:

    1. build_curriculum_manifest.py — walked curriculum/*.md to build
       the subject -> section -> topic -> tables nav tree.
    2. extract_highlights.py         — walked archives/NOTES/*.pdf,
       detected yellow cells, and emitted which rows were highlighted
       in each table.
    3. apply_highlights.py           — baked `<tr class="highlight">`
       into the curriculum markdown files from the extracted data.

The new design keeps highlight info in the manifest JSON itself
(`highlighted_rows` on each table) and applies the `highlight` class at
runtime via archives/LAYOUT/curriculum.js. Curriculum markdown files
therefore hold plain `<table>` HTML without any hardcoded classes —
they're pure content, and the JSON is the single source of highlight
state.

Usage:
    python3 archives/LAYOUT/build_curriculum.py
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

try:
    import pymupdf
except ImportError:  # pragma: no cover - surface a clear install hint
    sys.stderr.write(
        "pymupdf is required to extract highlights from the NOTES PDFs.\n"
        "Install with:  pip3 install pymupdf\n"
    )
    raise


# --------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------

# Canonical section order per subject (from the curriculum image).
# Falls back to alphabetical for any section not listed here.
SECTION_ORDER = {
    "mathematics": ["number-theory", "combinatorics", "geometry",
                    "algebra", "precalculus", "calculus"],
    "computing":   ["statistics", "inference", "language",
                    "computing", "learning", "sampling"],
    "physics":     ["mechanics", "harmonics", "electromagnetism",
                    "thermodynamics", "optics", "modern"],
    "chemistry":   ["atoms", "bonds", "stoichiometry",
                    "physical", "organic", "inorganic"],
    "biology":     ["cells", "genetics", "ecology",
                    "plants", "animals", "neuroscience"],
    "astronomy":   ["observations", "coordinates", "mechanics",
                    "solar-system", "stars", "cosmology"],
}

SUBJECT_NAMES = {
    "mathematics": "Mathematics",
    "computing":   "Computing",
    "physics":     "Physics",
    "chemistry":   "Chemistry",
    "biology":     "Biology",
    "astronomy":   "Astronomy",
}


# --------------------------------------------------------------------------
# Markdown front matter parsing
# --------------------------------------------------------------------------

def parse_frontmatter(text: str) -> dict:
    m = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return {}
    fm: dict = {}
    for line in m.group(1).split("\n"):
        if ":" in line:
            k, v = line.split(":", 1)
            fm[k.strip()] = v.strip()
    return fm


def slugify(s: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


# --------------------------------------------------------------------------
# PDF highlight extraction
# --------------------------------------------------------------------------

def is_yellow(rgb) -> bool:
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


def rect_overlap_area(a, b) -> float:
    if a is None or b is None:
        return 0.0
    dx = min(a[2], b[2]) - max(a[0], b[0])
    dy = min(a[3], b[3]) - max(a[1], b[1])
    if dx <= 0 or dy <= 0:
        return 0.0
    return dx * dy


def cell_is_yellow(cell_rect, yellows, min_fraction: float = 0.5) -> bool:
    if cell_rect is None:
        return False
    cw = cell_rect[2] - cell_rect[0]
    ch = cell_rect[3] - cell_rect[1]
    if cw <= 0 or ch <= 0:
        return False
    cell_area = cw * ch
    covered = sum(rect_overlap_area(cell_rect, y) for y in yellows)
    return covered / cell_area >= min_fraction


def cell_to_rect(cell):
    if cell is None:
        return None
    return (cell[0], cell[1], cell[2], cell[3])


def page_headers(page) -> tuple[str, str]:
    """Return (section, topic) from the top strip of a NOTES page.

    Layout: SECTION (e.g. "NUMBER THEORY") sits on the right edge of the
    header strip; TOPIC (e.g. "DIVISORS") a few lines below. Both are
    rendered in uppercase; topic is the first UPPERCASE block after the
    section line.
    """
    top_text = page.get_text("text", clip=(0, 0, page.rect.width, 130))
    lines = [ln.strip() for ln in top_text.splitlines() if ln.strip()]
    section = topic = ""
    for ln in lines:
        if ln.isupper() and len(ln) >= 2:
            if not section:
                section = ln
            elif not topic:
                topic = ln
                break
    return section.title(), topic.title()


def extract_highlights_from_pdf(pdf_path: Path) -> dict:
    """Return nested dict: section_title -> topic_title -> table_name -> [row indices]."""
    doc = pymupdf.open(pdf_path)
    result: dict = {}

    for page_num, page in enumerate(doc, start=1):
        yellows = page_yellow_rects(page)
        if not yellows:
            continue
        section, topic = page_headers(page)
        if not section or not topic:
            continue
        for t in page.find_tables():
            data = t.extract()
            if not data:
                continue
            header_cell = data[0][0] if data[0] else None
            if not header_cell:
                continue
            table_name = str(header_cell).strip()
            if not table_name:
                continue

            highlighted: list[int] = []
            row_objs = list(t.rows)
            for data_idx, (row_obj, _row_data) in enumerate(
                    zip(row_objs[1:], data[1:])):
                # Only inspect the middle/right cells — the leftmost
                # column often spans multiple rows with a section label
                # and would otherwise colour every sub-row.
                cell_rects = [cell_to_rect(c) for c in row_obj.cells[1:]]
                cell_rects = [cr for cr in cell_rects if cr is not None]
                if not cell_rects:
                    continue
                if any(cell_is_yellow(cr, yellows) for cr in cell_rects):
                    highlighted.append(data_idx)

            if highlighted:
                result.setdefault(section, {}) \
                      .setdefault(topic, {}) \
                      .setdefault(table_name, []) \
                      .extend(highlighted)

    return result


# --------------------------------------------------------------------------
# Manifest assembly
# --------------------------------------------------------------------------

def load_all_highlights(notes_dir: Path) -> dict:
    """Return {subject_slug: {section_title: {topic_title: {table_name: [rows]}}}}."""
    out: dict = {}
    for subj_slug in SUBJECT_NAMES:
        pdf = notes_dir / f"{subj_slug}.pdf"
        if not pdf.exists():
            continue
        print(f"Extracting highlights from {pdf.name}...", file=sys.stderr)
        out[subj_slug] = extract_highlights_from_pdf(pdf)
    return out


def highlighted_rows_for_table(hl_tree: dict,
                               subj_slug: str,
                               section_name: str,
                               topic_name: str,
                               table_name: str) -> list[int]:
    """Look up the row list with case-insensitive table matching.

    The manifest uses the display-case names from front matter (e.g.
    "Number Theory", "Divisors"), and the PDF extractor emits names
    with the same case via `.title()`. Table names are matched case
    insensitively because PDF table headers are sometimes lowercased.
    """
    subj = hl_tree.get(subj_slug, {})
    section = subj.get(section_name, {})
    topic = section.get(topic_name, {})
    for k, v in topic.items():
        if k.lower() == table_name.lower():
            return sorted(set(v))
    return []


def build_manifest(root: Path) -> dict:
    curr = root / "curriculum"
    hl_tree = load_all_highlights(root / "archives" / "NOTES")

    manifest: dict = {}
    for subj_slug, subj_name in SUBJECT_NAMES.items():
        subj_dir = curr / subj_slug
        if not subj_dir.is_dir():
            continue

        sections: dict[str, dict] = {}
        for section_dir in subj_dir.iterdir():
            if not section_dir.is_dir():
                continue
            section_slug = section_dir.name

            # Gather section display name (first front matter `section`
            # wins) and all tables in this section.
            section_display = section_slug.replace("-", " ").title()
            topics: dict[str, dict] = {}
            for md_file in section_dir.glob("*.md"):
                fm = parse_frontmatter(md_file.read_text(encoding="utf-8"))
                if fm.get("section"):
                    section_display = fm["section"]
                topic_name = fm.get(
                    "topic", md_file.stem.replace("-", " ").title())
                topic_slug = slugify(topic_name)
                table_name = fm.get(
                    "table", md_file.stem.replace("-", " ").title())
                try:
                    order = int(fm.get("order", "999"))
                except ValueError:
                    order = 999

                if topic_slug not in topics:
                    topics[topic_slug] = {
                        "slug": topic_slug,
                        "name": topic_name,
                        "tables": [],
                    }
                topics[topic_slug]["tables"].append({
                    "name": table_name,
                    "order": order,
                    "path": f"{subj_slug}/{section_slug}/{md_file.name}",
                    "highlighted_rows": highlighted_rows_for_table(
                        hl_tree, subj_slug, section_display,
                        topic_name, table_name),
                })

            if not topics:
                continue

            for t in topics.values():
                t["tables"].sort(key=lambda x: (x["order"], x["name"]))
            topics_list = sorted(
                topics.values(),
                key=lambda t: (t["tables"][0]["order"], t["name"]),
            )

            sections[section_slug] = {
                "slug": section_slug,
                "name": section_display,
                "topics": topics_list,
            }

        canonical = SECTION_ORDER.get(subj_slug, [])
        ordered_sections = [sections[s] for s in canonical if s in sections]
        remaining = sorted(s for s in sections if s not in canonical)
        ordered_sections.extend(sections[s] for s in remaining)

        manifest[subj_slug] = {
            "slug": subj_slug,
            "name": subj_name,
            "sections": ordered_sections,
        }

    return manifest


# --------------------------------------------------------------------------
# Entry point
# --------------------------------------------------------------------------

def main() -> None:
    root = Path(__file__).resolve().parent.parent.parent
    manifest = build_manifest(root)

    out_path = root / "archives" / "CONTENT" / "curriculum.json"
    out_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

    # Summary stats: how many tables got highlight info.
    total_tables = 0
    tables_with_hl = 0
    for subj in manifest.values():
        for sec in subj["sections"]:
            for topic in sec["topics"]:
                for table in topic["tables"]:
                    total_tables += 1
                    if table["highlighted_rows"]:
                        tables_with_hl += 1
    print(
        f"Wrote {out_path} "
        f"({out_path.stat().st_size} bytes, "
        f"{tables_with_hl}/{total_tables} tables with highlights)",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
