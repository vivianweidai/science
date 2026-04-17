#!/usr/bin/env python3
"""Build archives/truth/toys.json from the YAML source of truth.

Source of truth:  archives/truth/toys.yml
Output:           archives/truth/toys.json

Three-level schema:
  topics[] → technologies[] → toys[]

Output shape:
  {"topics": [{id, science, science_slug, topic,
    technologies: [{id, technology, description,
      toys: [{id, toy, specs, available, completed?, project_url?}]
    }]
  }]}
"""

from __future__ import annotations

import json
import sys
import urllib.parse
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")

ROOT = Path(__file__).resolve().parent.parent.parent
CONTENT = ROOT / "archives" / "CONTENT"
PROJECTS = ROOT / "research" / "projects"

SCIENCES = {"Biology", "Chemistry", "Physics", "Computing", "Mathematics", "Astronomy"}
SCIENCE_SLUGS = {
    "Biology": "bio", "Chemistry": "chem", "Physics": "phys",
    "Computing": "comp", "Mathematics": "math", "Astronomy": "astro",
}


def build() -> list[dict]:
    data = yaml.safe_load((CONTENT / "toys.yml").read_text())
    if not isinstance(data, list):
        raise ValueError("toys.yml must be a YAML list")
    topics = []
    tech_id = toy_id = 0
    for i, e in enumerate(data):
        for f in ("science", "topic", "technologies"):
            if f not in e:
                raise ValueError(f"topic[{i}] missing {f!r}")
        if e["science"] not in SCIENCES:
            raise ValueError(f"topic[{i}] invalid science {e['science']!r}")

        techs_out = []
        for j, tech in enumerate(e["technologies"]):
            for f in ("technology", "description"):
                if f not in tech:
                    raise ValueError(f"topic[{i}].tech[{j}] missing {f!r}")
            tech_id += 1
            toys_out = []
            for k, toy in enumerate(tech.get("toys") or []):
                for f in ("toy", "specs"):
                    if f not in toy:
                        raise ValueError(f"topic[{i}].tech[{j}].toy[{k}] missing {f!r}")
                toy_id += 1
                t: dict = {
                    "id": toy_id,
                    "toy": toy["toy"],
                    "specs": toy["specs"],
                    "available": 1 if toy.get("available") else 0,
                }
                if toy.get("url"):
                    t["url"] = toy["url"]
                if toy.get("completed"):
                    folder = toy["completed"]
                    t["completed"] = folder
                    t["project_url"] = f"/research/projects/{urllib.parse.quote(folder)}/"
                    if not (PROJECTS / folder).is_dir():
                        print(f"  warn: topic[{i}].tech[{j}].toy[{k}] → "
                              f"{folder!r} not found", file=sys.stderr)
                toys_out.append(t)
            techs_out.append({
                "id": tech_id,
                "technology": tech["technology"],
                "description": tech["description"],
                "toys": toys_out,
            })
        topics.append({
            "id": i + 1,
            "science": e["science"],
            "science_slug": SCIENCE_SLUGS[e["science"]],
            "topic": e["topic"],
            "description": e.get("description", ""),
            "technologies": techs_out,
        })
    return topics


def main() -> int:
    try:
        topics = build()
    except ValueError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    payload = {"topics": topics}
    out = CONTENT / "toys.json"
    out.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n")
    n_tech = sum(len(t["technologies"]) for t in topics)
    n_toys = sum(len(tech["toys"]) for t in topics for tech in t["technologies"])
    avail = sum(1 for t in topics for tech in t["technologies"]
                for toy in tech["toys"] if toy["available"])
    done = sum(1 for t in topics for tech in t["technologies"]
               for toy in tech["toys"] if toy.get("completed"))
    print(f"wrote {out.relative_to(ROOT)}")
    print(f"  {len(topics)} topics, {n_tech} technologies, {n_toys} toys")
    by = {}
    for t in topics:
        by.setdefault(t["science"], [0, 0, 0])
        by[t["science"]][0] += 1
        by[t["science"]][1] += len(t["technologies"])
        by[t["science"]][2] += sum(len(tech["toys"]) for tech in t["technologies"])
    for s in sorted(by):
        print(f"    {s}: {by[s][0]} topics, {by[s][1]} techs, {by[s][2]} toys")
    print(f"  available: {avail}  completed: {done}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
