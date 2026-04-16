#!/usr/bin/env python3
"""Build archives/CONTENT/toys.json from the YAML source of truth.

Source of truth:
  archives/CONTENT/toys.yml

Output (consumed by research/index.md client-side JS and by the iOS app):
  archives/CONTENT/toys.json

Output shape:
    {"items": [ {id, science, technology, principle, question, answer, state,
                 highlighted, available, completed?, project_url?}, ... ]}

Run this after editing the YAML, then commit both the YAML and the JSON.
There is no CI validation — the editor is responsible for remembering to rebuild.
"""

from __future__ import annotations

import json
import sys
import urllib.parse
from pathlib import Path

try:
    import yaml  # PyYAML
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")

ROOT = Path(__file__).resolve().parent.parent.parent
CONTENT = ROOT / "archives" / "CONTENT"
PROJECTS = ROOT / "research" / "projects"

SCIENCES = {"Biology", "Chemistry", "Physics", "Computing", "Mathematics", "Astronomy"}
SCIENCE_SLUGS = {
    "Biology": "bio",
    "Chemistry": "chem",
    "Physics": "phys",
    "Computing": "comp",
    "Mathematics": "math",
    "Astronomy": "astro",
}


def build_toys() -> list[dict]:
    data = yaml.safe_load((CONTENT / "toys.yml").read_text())
    if not isinstance(data, list):
        raise ValueError("toys.yml must be a YAML list")
    items = []
    for i, e in enumerate(data):
        # Validate required fields
        for field in ("science", "technology", "principle", "question", "answer", "state"):
            if field not in e:
                raise ValueError(f"entry[{i}] missing required field {field!r}: {e}")
        if e["science"] not in SCIENCES:
            raise ValueError(f"entry[{i}] invalid science {e['science']!r}")

        item: dict = {
            "id": i + 1,
            "science": e["science"],
            "science_slug": SCIENCE_SLUGS[e["science"]],
            "technology": e["technology"],
            "principle": e["principle"],
            "question": e["question"],
            "answer": e["answer"],
            "state": e["state"],
            "highlighted": 1 if e.get("highlighted") else 0,
            "available": 1 if e.get("available") else 0,
        }

        # Cross-link completed projects
        if e.get("completed"):
            folder = e["completed"]
            item["completed"] = folder
            # URL-encode the folder name for the project link
            encoded = urllib.parse.quote(folder)
            item["project_url"] = f"/research/projects/{encoded}/"
            # Validate that the project folder exists
            project_path = PROJECTS / folder
            if not project_path.is_dir():
                print(f"  warning: entry[{i}] references project folder "
                      f"{folder!r} but {project_path} does not exist",
                      file=sys.stderr)

        items.append(item)
    return items


def write_json(path: Path, items: list[dict]) -> None:
    payload = {"items": items}
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n")
    print(f"wrote {path.relative_to(ROOT)} ({len(items)} items)")


def summary(items: list[dict]) -> None:
    """Print a quick summary of the build."""
    by_science: dict[str, int] = {}
    available = 0
    completed = 0
    highlighted = 0
    for it in items:
        by_science[it["science"]] = by_science.get(it["science"], 0) + 1
        if it["available"]:
            available += 1
        if it.get("completed"):
            completed += 1
        if it["highlighted"]:
            highlighted += 1
    print(f"  total: {len(items)} toys")
    for s in sorted(by_science):
        print(f"    {s}: {by_science[s]}")
    print(f"  available: {available}  highlighted: {highlighted}  completed: {completed}")


def main() -> int:
    try:
        toys = build_toys()
    except ValueError as e:
        print(f"validation error: {e}", file=sys.stderr)
        return 1
    CONTENT.mkdir(exist_ok=True)
    write_json(CONTENT / "toys.json", toys)
    summary(toys)
    return 0


if __name__ == "__main__":
    sys.exit(main())
