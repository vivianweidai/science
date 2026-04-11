#!/usr/bin/env python3
"""Apply curriculum_highlights.json to all curriculum/*.md tables.

For each markdown file, look up its (subject, section, topic, table) in
archives/CONTENT/curriculum_highlights.json and rewrite the markdown
pipe-table as an HTML table, adding `<tr class="highlight">` on rows
whose description column matches any highlighted entry.

Rows not marked as highlighted are emitted as plain `<tr>`. Tables with
no highlighted rows are still converted (so rendering is consistent)
but can optionally be left as pipe tables.

Run after extract_highlights.py:
    python3 archives/LAYOUT/extract_highlights.py
    python3 archives/LAYOUT/apply_highlights.py
"""
from __future__ import annotations

import json
import re
from pathlib import Path


SUBJECT_MAP = {
    "Mathematics": "mathematics",
    "Computing": "computing",
    "Physics": "physics",
    "Chemistry": "chemistry",
    "Biology": "biology",
    "Astronomy": "astronomy",
}


def parse_frontmatter(text: str) -> tuple[dict, str]:
    m = re.match(r"^---\n(.*?)\n---\n?", text, re.DOTALL)
    if not m:
        return {}, text
    fm = {}
    for line in m.group(1).split("\n"):
        if ":" in line:
            k, v = line.split(":", 1)
            fm[k.strip()] = v.strip()
    return fm, text[m.end():]


def normalize(s: str) -> str:
    return re.sub(r"\s+", " ", s).strip().lower()


def find_pipe_table(body: str):
    """Locate the first markdown pipe table. Returns (start, end, header_cells, rows).

    Each row is a list of cell strings.
    """
    lines = body.split("\n")
    for i, line in enumerate(lines):
        if "|" in line and i + 1 < len(lines) and re.match(r"^\s*\|?[\s:|-]+\|[\s:|-]+", lines[i + 1]):
            start = i
            # Header row
            header = split_row(line)
            # Separator is at i+1
            rows = []
            j = i + 2
            while j < len(lines) and "|" in lines[j]:
                rows.append(split_row(lines[j]))
                j += 1
            end = j
            return start, end, header, rows
    return None


def split_row(line: str) -> list[str]:
    # Remove leading/trailing pipe if present
    s = line.strip()
    if s.startswith("|"):
        s = s[1:]
    if s.endswith("|"):
        s = s[:-1]
    return [c.strip() for c in s.split("|")]


def row_to_html(cells: list[str], tag: str, highlighted: bool) -> str:
    tr = '<tr class="highlight">' if highlighted else "<tr>"
    return tr + "".join(f"<{tag}>{c}</{tag}>" for c in cells) + "</tr>"


def build_html_table(header: list[str], rows: list[list[str]],
                     highlighted_indices: set[int]) -> str:
    out = ["<table>"]
    out.append(row_to_html(header, "th", False))
    for i, row in enumerate(rows):
        hl = i in highlighted_indices
        out.append(row_to_html(row, "td", hl))
    out.append("</table>")
    return "\n".join(out)


def process_file(md_path: Path, highlights: dict) -> tuple[bool, int, int]:
    text = md_path.read_text(encoding="utf-8")
    fm, body = parse_frontmatter(text)
    subj = fm.get("subject")
    section = fm.get("section")
    topic = fm.get("topic")
    table = fm.get("table")
    if not all([subj, section, topic, table]):
        return False, 0, 0

    subj_key = SUBJECT_MAP.get(subj)
    if not subj_key or subj_key not in highlights:
        return False, 0, 0

    # Look up highlights. The PDF table name is lowercase of the md `table`
    # field (e.g., `table: Divisors` <-> PDF header "divisors").
    subj_data = highlights[subj_key]
    section_data = subj_data.get(section, {})
    topic_data = section_data.get(topic, {})

    # Table key match is case-insensitive.
    table_key = None
    for k in topic_data:
        if k.lower() == table.lower():
            table_key = k
            break
    hl_rows = topic_data.get(table_key, []) if table_key else []
    highlighted_indices = {r["row"] for r in hl_rows}

    # Find and replace the pipe table.
    found = find_pipe_table(body)
    if not found:
        return False, 0, 0
    start, end, header, rows = found

    new_table = build_html_table(header, rows, highlighted_indices)

    body_lines = body.split("\n")
    new_body = "\n".join(body_lines[:start] + [new_table] + body_lines[end:])

    # Reconstruct file with frontmatter.
    fm_lines = ["---"]
    for k, v in fm.items():
        fm_lines.append(f"{k}: {v}")
    fm_lines.append("---")
    new_text = "\n".join(fm_lines) + "\n" + new_body

    if new_text != text:
        md_path.write_text(new_text, encoding="utf-8")

    matched = sum(1 for i in range(len(rows)) if i in highlighted_indices)
    return True, len(highlighted_indices), matched


def main():
    root = Path(__file__).resolve().parent.parent.parent
    highlights = json.loads((root / "archives" / "CONTENT" / "curriculum_highlights.json").read_text())

    stats = {"files": 0, "converted": 0, "highlight_targets": 0, "highlight_matched": 0,
             "unmatched": []}
    for md in sorted((root / "curriculum").glob("**/*.md")):
        stats["files"] += 1
        converted, targets, matched = process_file(md, highlights)
        if converted:
            stats["converted"] += 1
            stats["highlight_targets"] += targets
            stats["highlight_matched"] += matched
            if targets != matched:
                stats["unmatched"].append((str(md.relative_to(root)), targets, matched))

    print(f"Files scanned:     {stats['files']}")
    print(f"Tables converted:  {stats['converted']}")
    print(f"Targets/Matched:   {stats['highlight_targets']} / {stats['highlight_matched']}")
    if stats["unmatched"]:
        print(f"\nFiles with unmatched highlights ({len(stats['unmatched'])}):")
        for p, t, m in stats["unmatched"][:40]:
            print(f"  {p}: {m}/{t}")


if __name__ == "__main__":
    main()
