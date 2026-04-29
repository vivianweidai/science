#!/usr/bin/env python3
"""Build public/research/toys.json from the YAML source of truth.

Source of truth:  public/research/toys.yml
Output:           public/research/toys.json

Three-level schema:
  topics[] → technologies[] → toys[]

Output shape:
  {"topics": [{id, science, science_slug, topic, description,
    technologies: [{id, technology, description,
      toys: [{id, toy, specs, available, toy_url, hero?, url?,
              projects?: [{date, title, url, sciences[], folder?}]}]
    }]
  }]}

The `projects[]` list is the one source for toy↔project links. It's
assembled by reverse-scanning every research project's `index.md`
frontmatter `toys:` array (each project declares which toys it used)
plus each toy's own `extra_projects:` placeholder list.
"""

from __future__ import annotations

import json
import re
import sys
import urllib.parse
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")

ROOT = Path(__file__).resolve().parent.parent.parent
CONTENT = ROOT / "public" / "research"
PROJECTS = CONTENT / "projects"
TOYS_DIR = CONTENT / "toys"

SCIENCES = {"Biology", "Chemistry", "Physics", "Computing", "Mathematics", "Astronomy"}
# Short slug — used for chip styling and the /research/#<slug> column anchor.
SCIENCE_SLUGS = {
    "Biology": "bio", "Chemistry": "chem", "Physics": "phys",
    "Computing": "comp", "Mathematics": "math", "Astronomy": "astro",
}
# Folder name on disk and in URLs — full word, matching public/curriculum/source.
SCIENCE_FOLDERS = {
    "Biology": "biology", "Chemistry": "chemistry", "Physics": "physics",
    "Computing": "computing", "Mathematics": "mathematics", "Astronomy": "astronomy",
}


def _read_frontmatter(md_path: Path) -> dict | None:
    """Parse the YAML frontmatter at the top of a markdown file.
    Returns None when the file is missing or has no `---\\n…\\n---` block."""
    if not md_path.is_file():
        return None
    text = md_path.read_text()
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 4)
    if end < 0:
        return None
    return yaml.safe_load(text[4:end]) or {}


def hero_for_toy(science_folder: str, toy_name: str) -> str | None:
    """Return absolute hero-image URL for a toy by reading its index.md
    frontmatter (`hero:` field). Returns None when no toy folder exists yet
    or when the frontmatter has no hero. Relative paths in frontmatter are
    resolved against the toy folder's URL."""
    fm = _read_frontmatter(TOYS_DIR / science_folder / toy_name / "index.md")
    if not fm:
        return None
    hero = fm.get("hero")
    if not hero:
        return None
    if hero.startswith(("/", "http://", "https://")):
        return hero
    base = f"/research/toys/{science_folder}/{urllib.parse.quote(toy_name)}/"
    return base + urllib.parse.quote(hero)


def extras_for_toy(science_folder: str, toy_name: str) -> list[dict]:
    """Return the toy's `extra_projects:` frontmatter array — placeholder
    entries for projects that don't have a local research folder yet
    (external links, planned projects, etc.). Each entry is normalised to
    {date, title, url, sciences[]} with `date` as YYYY-MM-DD."""
    fm = _read_frontmatter(TOYS_DIR / science_folder / toy_name / "index.md")
    if not fm:
        return []
    out = []
    for x in fm.get("extra_projects") or []:
        date = str(x.get("date", ""))
        m = re.match(r"^(\d{4})-(\d{2})-(\d{2})", date)
        if not m:
            continue
        out.append({
            "date": f"{m.group(1)}-{m.group(2)}-{m.group(3)}",
            "title": x.get("title", ""),
            "url": x.get("url", ""),
            "sciences": list(x.get("sciences") or []),
        })
    return out


def projects_per_toy() -> dict[str, list[dict]]:
    """Scan every research project's index.md and return a reverse map
    from toy name to the list of projects that reference it via the
    project's `toys:` frontmatter array. Each entry is {date, title,
    url, sciences[], folder}, with `date` as YYYY-MM-DD parsed from the
    folder's date prefix. Used to bake the per-toy projects list into
    toys.json so iOS/Android can render the toy page natively without
    re-scanning all projects at runtime."""
    by_toy: dict[str, list[dict]] = {}
    if not PROJECTS.is_dir():
        return by_toy
    for proj in sorted(PROJECTS.iterdir()):
        if not proj.is_dir():
            continue
        m = re.match(r"^(\d{4})(\d{2})(\d{2})", proj.name)
        if not m:
            continue
        date_iso = f"{m.group(1)}-{m.group(2)}-{m.group(3)}"
        fm = _read_frontmatter(proj / "index.md")
        if not fm:
            continue
        title = fm.get("title", fm.get("project", ""))
        sciences = list(fm.get("sciences") or [])
        url = f"/research/projects/{urllib.parse.quote(proj.name)}/"
        for t in fm.get("toys") or []:
            by_toy.setdefault(str(t), []).append({
                "date": date_iso,
                "title": title,
                "url": url,
                "sciences": sciences,
                "folder": proj.name,
            })
    return by_toy


def build() -> list[dict]:
    data = yaml.safe_load((CONTENT / "toys.yml").read_text())
    if not isinstance(data, list):
        raise ValueError("toys.yml must be a YAML list")
    proj_index = projects_per_toy()
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
                folder = SCIENCE_FOLDERS[e["science"]]
                t: dict = {
                    "id": toy_id,
                    "toy": toy["toy"],
                    "specs": toy["specs"],
                    "available": 1 if toy.get("available") else 0,
                    "toy_url": (
                        f"/research/toys/{folder}/"
                        f"{urllib.parse.quote(toy['toy'])}/"
                    ),
                }
                hero = hero_for_toy(folder, toy["toy"])
                if hero:
                    t["hero"] = hero
                if toy.get("url"):
                    t["url"] = toy["url"]
                # Combine reverse-scanned projects (project frontmatter
                # `toys:` array) with the toy's own `extra_projects:`
                # placeholder list, sort newest first by date.
                folder_for_extras = SCIENCE_FOLDERS[e["science"]]
                projects = list(proj_index.get(toy["toy"], []))
                projects.extend(extras_for_toy(folder_for_extras, toy["toy"]))
                if projects:
                    projects.sort(key=lambda p: p["date"], reverse=True)
                    t["projects"] = projects
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
    print(f"  available: {avail}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
