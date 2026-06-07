"""
Verify version consistency across README.md, CLAUDE.md, AGENTS.md, and CHANGELOG.md.
Exit 0 if all match. Exit 1 if any mismatch.
"""

import sys
import re
import os
from pathlib import Path

# Windows UTF-8 output
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

ROOT = Path(__file__).parent.parent

def extract_version_changelog(path: Path) -> str | None:
    """Return version from first ## [x.y.z] line in CHANGELOG."""
    text = path.read_text(encoding="utf-8")
    m = re.search(r"^## \[(\d+\.\d+\.\d+)\]", text, re.MULTILINE)
    return m.group(1) if m else None

def extract_version_file(path: Path, label: str) -> str | None:
    """Return version from a line containing 'label ... vX.Y.Z'."""
    text = path.read_text(encoding="utf-8")
    # Match label anywhere on a line, followed later on the same line by vX.Y.Z
    m = re.search(rf"{re.escape(label)}[^\n]*v(\d+\.\d+\.\d+)", text)
    return m.group(1) if m else None

def count_skills() -> int:
    skills_dir = ROOT / "skills"
    return len(list(skills_dir.glob("*/SKILL.md")))

def count_agents() -> int:
    agents_dir = ROOT / ".claude" / "agents"
    return len(list(agents_dir.glob("*.md")))

PACK_LABEL = "builder-design"

changelog_version = extract_version_changelog(ROOT / "CHANGELOG.md")
readme_version    = extract_version_file(ROOT / "README.md",   PACK_LABEL)
claude_version    = extract_version_file(ROOT / "CLAUDE.md",   PACK_LABEL)
agents_version    = extract_version_file(ROOT / "AGENTS.md",   PACK_LABEL)

skill_count = count_skills()
agent_count = count_agents()

print(f"builder-design consistency check")
print(f"  CHANGELOG.md : {changelog_version or '(not found)'}")
print(f"  README.md    : {readme_version    or '(not found)'}")
print(f"  CLAUDE.md    : {claude_version    or '(not found)'}")
print(f"  AGENTS.md    : {agents_version    or '(not found)'}")
print(f"  Skills found : {skill_count}")
print(f"  Agents found : {agent_count}")

mismatches = []
for label, version in [("README.md", readme_version), ("CLAUDE.md", claude_version), ("AGENTS.md", agents_version)]:
    if version != changelog_version:
        mismatches.append(f"  {label} has v{version} — expected v{changelog_version} (from CHANGELOG.md)")

if mismatches:
    print("\nMISMATCHES FOUND:")
    for m in mismatches:
        print(m)
    sys.exit(1)

print("\nAll versions consistent. ✓")
sys.exit(0)
