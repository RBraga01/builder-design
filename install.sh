#!/usr/bin/env bash
set -euo pipefail

# builder-design install script
# Sparse-clones skills/ and .claude/agents/ into the target directory

REPO="https://github.com/RBraga01/builder-design.git"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[builder-design]${NC} $1"; }
warn()  { echo -e "${YELLOW}[builder-design]${NC} $1"; }
error() { echo -e "${RED}[builder-design]${NC} $1" >&2; exit 1; }

# Preflight checks
command -v git >/dev/null 2>&1 || error "git is required but not installed."

DEST="${1:-.}"
[[ -d "$DEST" ]] || error "Destination directory '$DEST' does not exist."

info "Installing builder-design into $DEST"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

info "Cloning (sparse)..."
git clone --filter=blob:none --sparse --quiet "$REPO" "$TMP/builder-design"
cd "$TMP/builder-design"
git sparse-checkout set skills .claude/agents

info "Copying skills..."
if cp -rn skills/ "$DEST/" 2>/dev/null; then
  SKILL_COUNT=$(find "$DEST/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  info "  $SKILL_COUNT skills installed"
else
  warn "  skills/ already exists — skipping (use --force to overwrite)"
fi

info "Copying agents..."
mkdir -p "$DEST/.claude"
if cp -rn .claude/agents/ "$DEST/.claude/" 2>/dev/null; then
  AGENT_COUNT=$(find "$DEST/.claude/agents" -name "*.md" | wc -l | tr -d ' ')
  info "  $AGENT_COUNT agents installed"
else
  warn "  .claude/agents/ already exists — skipping (use --force to overwrite)"
fi

info "Done. builder-design v1.0.0 installed."
echo ""
echo "  Skills:    $DEST/skills/"
echo "  Agents:    $DEST/.claude/agents/"
echo ""
echo "  Start with: ai-states-required (before any component code)"
echo "  Then:        design-before-code (spec before implementation)"
