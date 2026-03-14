#!/bin/bash
# Sync Claude Code skills between local (~/.claude/skills) and dotfiles repo
# Pulls new skills from repo → local, pushes new local skills → repo

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_SKILLS="$DOTFILES_DIR/claude/skills"
LOCAL_SKILLS="$HOME/.claude/skills"

mkdir -p "$REPO_SKILLS" "$LOCAL_SKILLS"

echo "Syncing Claude Code skills..."

# Pull latest from remote
echo ""
echo "Pulling latest from remote..."
git -C "$DOTFILES_DIR" pull --rebase --quiet

# Repo → Local: copy skills that exist in repo but not locally
echo ""
echo "=== Repo → Local ==="
for skill_dir in "$REPO_SKILLS"/*/; do
    [ ! -d "$skill_dir" ] && continue
    skill_name=$(basename "$skill_dir")
    if [ ! -e "$LOCAL_SKILLS/$skill_name" ]; then
        echo "  + $skill_name (new from repo)"
        ln -s "$skill_dir" "$LOCAL_SKILLS/$skill_name"
    else
        echo "  . $skill_name (already exists)"
    fi
done

# Local → Repo: copy skills that exist locally but not in repo
echo ""
echo "=== Local → Repo ==="
changed=false
for skill_dir in "$LOCAL_SKILLS"/*/; do
    [ ! -d "$skill_dir" ] && continue
    skill_name=$(basename "$skill_dir")
    # Resolve symlinks to get the real path
    real_path=$(readlink -f "$skill_dir")
    if [ ! -d "$REPO_SKILLS/$skill_name" ]; then
        echo "  + $skill_name (new from local)"
        cp -r "$real_path" "$REPO_SKILLS/$skill_name"
        # Replace local copy with symlink to repo
        rm -rf "$LOCAL_SKILLS/$skill_name"
        ln -s "$REPO_SKILLS/$skill_name" "$LOCAL_SKILLS/$skill_name"
        changed=true
    else
        echo "  . $skill_name (already in repo)"
    fi
done

# Push if there were changes
if $changed; then
    echo ""
    echo "Pushing new skills to remote..."
    git -C "$DOTFILES_DIR" add claude/skills/
    git -C "$DOTFILES_DIR" commit -m "Sync new skills from $(hostname -s)"
    git -C "$DOTFILES_DIR" push
    echo "Pushed."
else
    echo ""
    echo "No new skills to push."
fi

echo ""
echo "✅ Skills in sync."
