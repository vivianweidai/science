#!/usr/bin/env python3
"""Regenerate archives/CONTENT/curriculum_manifest.json from curriculum/*.md.

Walks the curriculum tree, parses each file's front matter, and emits a
hierarchical manifest: subject -> sections -> topics -> tables (files).

Run whenever curriculum content is added/renamed/reordered:
    python3 archives/LAYOUT/build_curriculum_manifest.py
"""
import json
import re
from pathlib import Path

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


def parse_frontmatter(text: str) -> dict:
    m = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return {}
    fm = {}
    for line in m.group(1).split("\n"):
        if ":" in line:
            k, v = line.split(":", 1)
            fm[k.strip()] = v.strip()
    return fm


def slugify(s: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def main() -> None:
    root = Path(__file__).resolve().parent.parent.parent
    curr = root / "curriculum"

    manifest = {}
    for subj_slug, subj_name in SUBJECT_NAMES.items():
        subj_dir = curr / subj_slug
        if not subj_dir.is_dir():
            continue

        # Collect all tables (files) grouped by section and topic.
        sections: dict[str, dict] = {}
        for section_dir in subj_dir.iterdir():
            if not section_dir.is_dir():
                continue
            section_slug = section_dir.name
            topics: dict[str, dict] = {}
            for md_file in section_dir.glob("*.md"):
                fm = parse_frontmatter(md_file.read_text(encoding="utf-8"))
                topic_name = fm.get("topic", md_file.stem.replace("-", " ").title())
                topic_slug = slugify(topic_name)
                table_name = fm.get("table", md_file.stem.replace("-", " ").title())
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
                })

            if not topics:
                continue

            # Sort tables within each topic by order, and topics within
            # section by the minimum order of their tables.
            for t in topics.values():
                t["tables"].sort(key=lambda x: (x["order"], x["name"]))
            topics_list = sorted(
                topics.values(),
                key=lambda t: (t["tables"][0]["order"], t["name"]),
            )

            # Section display name: use the `section` front matter if any
            # file provides it, otherwise title-case the slug.
            section_display = section_slug.replace("-", " ").title()
            for md_file in section_dir.glob("*.md"):
                fm = parse_frontmatter(md_file.read_text(encoding="utf-8"))
                if fm.get("section"):
                    section_display = fm["section"]
                    break

            sections[section_slug] = {
                "slug": section_slug,
                "name": section_display,
                "topics": topics_list,
            }

        # Canonical section order, then append any unlisted sections alphabetically.
        canonical = SECTION_ORDER.get(subj_slug, [])
        ordered_sections = [sections[s] for s in canonical if s in sections]
        remaining = sorted(s for s in sections if s not in canonical)
        ordered_sections.extend(sections[s] for s in remaining)

        manifest[subj_slug] = {
            "slug": subj_slug,
            "name": subj_name,
            "sections": ordered_sections,
        }

    out_path = root / "archives" / "CONTENT" / "curriculum_manifest.json"
    out_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {out_path} ({out_path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
