#!/usr/bin/env bash
# bootstrap.sh — Set up LifeOS on a new Mac, or repair after restructure
# Idempotent: safe to run multiple times.

set -euo pipefail

log()    { printf "\033[1;34m[bootstrap]\033[0m %s\n" "$*"; }
ok()     { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
warn()   { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err()    { printf "\033[1;31m[error]\033[0m %s\n" "$*" >&2; exit 1; }

LIFEOS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GETBETTERAT_REPO="$HOME/workspace/GetBetterAt"
DRIVE_BASE="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive"
LIFEOS_DRIVE="$DRIVE_BASE/LifeOS"
SHELL_RC="${SHELL_RC:-$HOME/.zshrc}"

step_check_dependencies() {
    log "Checking dependencies..."

    [ -d "$GETBETTERAT_REPO" ] || err "GetBetterAt repo not found at $GETBETTERAT_REPO. Clone first: git clone https://github.com/ashish-sadh/GetBetterAt.git"
    [ -d "$DRIVE_BASE" ] || err "Drive Desktop not found. Install: https://www.google.com/drive/download/"

    command -v claude > /dev/null || err "Claude Code CLI not installed. See https://docs.claude.com/en/docs/claude-code/setup"

    ok "Dependencies present"
}

step_link_skills() {
    log "Linking skills (LifeOS uses GetBetterAt's skills)..."

    if [ -L "$LIFEOS_REPO/.claude/skills" ]; then
        ok "LifeOS skills symlink already exists"
    else
        rm -rf "$LIFEOS_REPO/.claude/skills" 2>/dev/null
        ln -sfn "$GETBETTERAT_REPO/skills" "$LIFEOS_REPO/.claude/skills"
        ok "Created LifeOS skills symlink → GetBetterAt/skills"
    fi

    if [ -L "$HOME/.claude/skills" ]; then
        ok "User-global skills symlink already exists"
    else
        if [ -d "$HOME/.claude/skills" ]; then
            mv "$HOME/.claude/skills" "$HOME/.claude/skills.bak.$(date +%Y%m%d)"
        fi
        mkdir -p "$HOME/.claude"
        ln -sfn "$LIFEOS_REPO/.claude/skills" "$HOME/.claude/skills"
        ok "Created user-global skills symlink → LifeOS/.claude/skills"
    fi
}

step_set_aliases() {
    log "Setting up shell aliases in $SHELL_RC..."

    if grep -q "# LifeOS aliases" "$SHELL_RC" 2>/dev/null; then
        warn "Aliases already in $SHELL_RC; skipping"
        return
    fi

    cat >> "$SHELL_RC" <<EOF

# LifeOS aliases — managed by bootstrap.sh
export LIFEOS_REPO="$LIFEOS_REPO"
export LIFEOS_DATA="$LIFEOS_DRIVE"
export LIFEOS="\$LIFEOS_DATA"  # backward-compat for existing skills

alias pole='cd "\$LIFEOS_DATA/GetBetterAt/Pole" && claude --dangerously-skip-permissions'
alias think='cd "\$LIFEOS_DATA/GetBetterAt/Thinking" && claude --dangerously-skip-permissions'
alias fit='cd "\$LIFEOS_DATA/GetBetterAt/Fitness" && claude --dangerously-skip-permissions'
alias speak='cd "\$LIFEOS_DATA/GetBetterAt/Speaking" && claude --dangerously-skip-permissions'
alias cook='cd "\$LIFEOS_DATA/GetBetterAt/Cooking" && claude --dangerously-skip-permissions'
alias org='cd "\$LIFEOS_DATA/GetBetterAt/Organized" && claude --dangerously-skip-permissions'
alias assist='cd "\$LIFEOS_DATA/Assistant" && claude --dangerously-skip-permissions'
alias brain='cd "\$LIFEOS_DATA" && claude --dangerously-skip-permissions'
EOF

    ok "Aliases added. Run 'source $SHELL_RC' or open new terminal to activate."
}

step_init_caches() {
    log "Initializing cache files..."
    mkdir -p "$HOME/.cache/lifeos-logs"

    if [ ! -f "$HOME/.cache/vault-processed-inbox.json" ]; then
        cat > "$HOME/.cache/vault-processed-inbox.json" <<'EOF'
{
  "version": 1,
  "_comment": "Tracks Drive inbox file IDs already processed by Mac",
  "last_pull": null,
  "processed_ids": {}
}
EOF
        ok "vault-processed-inbox.json initialized"
    fi

    if [ ! -f "$HOME/.cache/vault-last-maintenance.json" ]; then
        cat > "$HOME/.cache/vault-last-maintenance.json" <<'EOF'
{"version": 1, "last_run": null, "actions_history": []}
EOF
        ok "vault-last-maintenance.json initialized"
    fi
}

step_verify_drive_structure() {
    log "Verifying Drive vault structure exists..."

    [ -d "$LIFEOS_DRIVE" ] || err "Drive vault not found at $LIFEOS_DRIVE. Create it manually first or restore from backup."

    for dir in _shared GetBetterAt Assistant People Places Restaurants Events Daily Ideas Projects Reading Archive proposals; do
        if [ ! -d "$LIFEOS_DRIVE/$dir" ]; then
            mkdir -p "$LIFEOS_DRIVE/$dir"
            ok "Created $LIFEOS_DRIVE/$dir"
        fi
    done

    ok "Drive vault structure verified"
}

step_print_next() {
    cat <<EOF

──────────────────────────────────────────────────────────────────────────
✅ LifeOS bootstrap complete

Code:        $LIFEOS_REPO
Framework:   $GETBETTERAT_REPO
Data:        $LIFEOS_DRIVE
Shell:       $SHELL_RC

Next steps:
1. Reload shell: source $SHELL_RC (or open new terminal)
2. Authenticate Drive in Claude: in any Claude session, run /mcp → Google Drive
3. Spawn first coach: brain → "spawn a [domain] coach"
4. Set up Claude.ai Project per coach: see _ai/claude-ai.md

To enable scheduled jobs: cp .claude/scheduled/launchd/*.plist ~/Library/LaunchAgents/
──────────────────────────────────────────────────────────────────────────
EOF
}

main() {
    log "LifeOS bootstrap starting..."
    step_check_dependencies
    step_link_skills
    step_set_aliases
    step_init_caches
    step_verify_drive_structure
    step_print_next
}

main "$@"
