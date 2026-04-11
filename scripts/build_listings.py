#!/usr/bin/env python3
"""Build archives/olympiads.json and archives/textbooks.json from the YAML source of truth.

Source of truth:
  content/olympiads.yml
  content/textbooks.yml

Outputs (consumed by olympiads/index.md client-side JS and by the iOS app):
  archives/olympiads.json
  archives/textbooks.json

Output shape matches the old Cloudflare Pages Function response so the iOS app can
decode it without code changes:
    {"items": [ {id, subject, date, sort_key, country, name, finished, highlighted}, ... ]}

Run this after editing either YAML file, then commit both the YAML and the JSON.
A GitHub Action (.github/workflows/build-listings.yml) also runs this on push and
will fail the build if the committed JSON is stale.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

try:
    import yaml  # PyYAML
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")

ROOT = Path(__file__).resolve().parent.parent
CONTENT = ROOT / "content"
ARCHIVES = ROOT / "archives"

SUBJECTS = {"Mathematics", "Computing", "Physics", "Chemistry", "Biology", "Astronomy"}
MONTHS = {
    "January": "01", "February": "02", "March": "03", "April": "04",
    "May": "05", "June": "06", "July": "07", "August": "08",
    "September": "09", "October": "10", "November": "11", "December": "12",
}


def sort_key(date: str) -> str:
    """'November 2025' -> '2025-11'; 'Future' -> '9999-12'."""
    if date == "Future":
        return "9999-12"
    try:
        month, year = date.split(" ")
        return f"{year}-{MONTHS[month]}"
    except (ValueError, KeyError) as e:
        raise ValueError(f"invalid date {date!r}: expected 'Month YYYY' or 'Future'") from e


def validate_common(entry: dict, idx: int, kind: str) -> None:
    for field in ("subject", "date", "finished", "highlighted"):
        if field not in entry:
            raise ValueError(f"{kind}[{idx}] missing required field {field!r}: {entry}")
    if entry["subject"] not in SUBJECTS:
        raise ValueError(f"{kind}[{idx}] invalid subject {entry['subject']!r}")
    if not isinstance(entry["finished"], bool):
        raise ValueError(f"{kind}[{idx}] finished must be true/false")
    if not isinstance(entry["highlighted"], bool):
        raise ValueError(f"{kind}[{idx}] highlighted must be true/false")


def build_olympiads() -> list[dict]:
    data = yaml.safe_load((CONTENT / "olympiads.yml").read_text())
    if not isinstance(data, list):
        raise ValueError("olympiads.yml must be a YAML list")
    items = []
    for i, e in enumerate(data):
        validate_common(e, i, "olympiad")
        for field in ("country", "name"):
            if field not in e:
                raise ValueError(f"olympiad[{i}] missing required field {field!r}")
        items.append({
            "id": i + 1,
            "subject": e["subject"],
            "date": e["date"],
            "sort_key": sort_key(e["date"]),
            "country": e["country"],
            "name": e["name"],
            "finished": 1 if e["finished"] else 0,
            "highlighted": 1 if e["highlighted"] else 0,
        })
    return items


def build_textbooks() -> list[dict]:
    data = yaml.safe_load((CONTENT / "textbooks.yml").read_text())
    if not isinstance(data, list):
        raise ValueError("textbooks.yml must be a YAML list")
    items = []
    for i, e in enumerate(data):
        validate_common(e, i, "textbook")
        if "title" not in e:
            raise ValueError(f"textbook[{i}] missing required field 'title'")
        if "link_text" in e and "url" not in e:
            raise ValueError(f"textbook[{i}] has link_text without url")
        if "link_text" in e and e["link_text"] not in e["title"]:
            raise ValueError(
                f"textbook[{i}] link_text {e['link_text']!r} not a substring of title"
            )
        item = {
            "id": i + 1,
            "subject": e["subject"],
            "date": e["date"],
            "sort_key": sort_key(e["date"]),
            "title": e["title"],
            "finished": 1 if e["finished"] else 0,
            "highlighted": 1 if e["highlighted"] else 0,
        }
        # Webapp-only fields (iOS ignores unknown keys).
        if "url" in e:
            item["url"] = e["url"]
        if "link_text" in e:
            item["link_text"] = e["link_text"]
        items.append(item)
    return items


def write_json(path: Path, items: list[dict]) -> None:
    payload = {"items": items}
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n")
    print(f"wrote {path.relative_to(ROOT)} ({len(items)} items)")


def main() -> int:
    try:
        olympiads = build_olympiads()
        textbooks = build_textbooks()
    except ValueError as e:
        print(f"validation error: {e}", file=sys.stderr)
        return 1
    ARCHIVES.mkdir(exist_ok=True)
    write_json(ARCHIVES / "olympiads.json", olympiads)
    write_json(ARCHIVES / "textbooks.json", textbooks)
    return 0


if __name__ == "__main__":
    sys.exit(main())
