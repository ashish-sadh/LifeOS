#!/usr/bin/env bash
# bootstrap.sh — Set up LifeOS on a new Mac, or repair/update an existing install.
# Idempotent: safe to run multiple times.
# Requires: bash (uses BASH_SOURCE), Claude Code CLI.

set -euo pipefail

log()  { printf "\033[1;34m[bootstrap]\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[error]\033[0m %s\n" "$*" >&2; exit 1; }

# Repo root is one level above scripts/
LIFEOS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHELL_RC="${SHELL_RC:-$HOME/.zshrc}"

# ---------------------------------------------------------------------------
# Detect vault path: VAULT env var → Drive Desktop mount → ~/Documents/Vault
# ---------------------------------------------------------------------------
detect_vault_path() {
    if [ -n "${VAULT:-}" ]; then
        echo "$VAULT"
        return
    fi
    local drive_account
    drive_account=$(ls "$HOME/Library/CloudStorage/" 2>/dev/null | grep "^GoogleDrive-" | head -1 || true)
    if [ -n "$drive_account" ]; then
        echo "$HOME/Library/CloudStorage/$drive_account/My Drive/Vault"
        return
    fi
    echo "$HOME/Documents/Vault"
}

VAULT_PATH="$(detect_vault_path)"

# ---------------------------------------------------------------------------
step_check_dependencies() {
    log "Checking dependencies..."

    command -v claude > /dev/null 2>&1 || err "Claude Code CLI not found. Install: https://docs.claude.com/en/docs/claude-code/setup"

    if ! ls "$HOME/Library/CloudStorage/GoogleDrive-"* > /dev/null 2>&1; then
        warn "Google Drive Desktop not detected — vault will be at ~/Documents/Vault."
        warn "Drive Desktop is recommended for phone sync. See docs/drive-desktop.md"
        warn "After installing Drive Desktop, re-run bootstrap.sh to update your VAULT path."
    fi

    ok "Dependencies checked"
}

# ---------------------------------------------------------------------------
step_link_skills() {
    log "Linking skills to ~/.claude/skills..."

    local target="$LIFEOS_REPO/skills"
    local link="$HOME/.claude/skills"

    if [ -L "$link" ]; then
        ok "~/.claude/skills symlink already exists ($(readlink "$link"))"
        return
    fi

    if [ -d "$link" ]; then
        local backup="$link.bak.$(date +%Y%m%d%H%M%S)"
        mv "$link" "$backup"
        warn "Backed up existing ~/.claude/skills → $backup"
    fi

    mkdir -p "$HOME/.claude"
    ln -sfn "$target" "$link"
    ok "Linked ~/.claude/skills → $target"
}

# ---------------------------------------------------------------------------
step_create_vault() {
    log "Setting up vault at $VAULT_PATH..."

    mkdir -p "$VAULT_PATH"

    local dirs="Coaches Assistant People Places Restaurants Events Daily Ideas Projects Reading Archive proposals _shared"
    for dir in $dirs; do
        if [ ! -d "$VAULT_PATH/$dir" ]; then
            mkdir -p "$VAULT_PATH/$dir"
            ok "Created $dir/"
        fi
    done

    # Seed _shared templates if not yet present
    for f in profile.md principles.md schedule.md; do
        if [ ! -f "$VAULT_PATH/_shared/$f" ] && [ -f "$LIFEOS_REPO/templates/_shared/$f" ]; then
            cp "$LIFEOS_REPO/templates/_shared/$f" "$VAULT_PATH/_shared/$f"
            ok "Seeded _shared/$f from template"
        fi
    done

    # Create Inbox.md if missing
    if [ ! -f "$VAULT_PATH/Inbox.md" ]; then
        cat > "$VAULT_PATH/Inbox.md" <<'INBOX'
# Inbox

Quick captures from phone or desktop. Process regularly via `inbox-triage` skill or by typing `brain` and saying "triage my inbox."

INBOX
        ok "Created Inbox.md"
    fi

    ok "Vault ready"
}

# ---------------------------------------------------------------------------
step_set_aliases() {
    log "Configuring shell aliases in $SHELL_RC..."

    if grep -q "# LifeOS aliases" "$SHELL_RC" 2>/dev/null; then
        warn "LifeOS aliases block already present in $SHELL_RC — skipping."
        warn "To update the VAULT path, edit the 'export VAULT=...' line in $SHELL_RC manually."
        return
    fi

    cat >> "$SHELL_RC" <<ALIASES

# LifeOS aliases — managed by bootstrap.sh
export VAULT="${VAULT_PATH}"
export LIFEOS_REPO="${LIFEOS_REPO}"

# brain: entry point to vault root — use this to spawn coaches, triage inbox, run weekly review
alias brain='cd "\$VAULT" && claude --dangerously-skip-permissions'
# Coach aliases (pole, cook, think, fit, speak, etc.) are added by spawn-coach when you create each coach.
ALIASES

    ok "Aliases added."
    ok "Run: source $SHELL_RC  (or open a new terminal tab)"
}

# ---------------------------------------------------------------------------
step_init_caches() {
    log "Initializing cache files..."

    mkdir -p "$HOME/.cache/lifeos-logs"

    if [ ! -f "$HOME/.cache/vault-processed-inbox.json" ]; then
        printf '{"version":1,"_comment":"Drive inbox file IDs already integrated by Mac","last_pull":null,"processed_ids":{}}\n' \
            > "$HOME/.cache/vault-processed-inbox.json"
        ok "vault-processed-inbox.json created"
    fi

    if [ ! -f "$HOME/.cache/vault-last-maintenance.json" ]; then
        printf '{"version":1,"last_run":null,"actions_history":[]}\n' \
            > "$HOME/.cache/vault-last-maintenance.json"
        ok "vault-last-maintenance.json created"
    fi
}

# ---------------------------------------------------------------------------
step_print_next() {
    cat <<NEXT

──────────────────────────────────────────────────────────────────────────
LifeOS bootstrap complete

Repo:   $LIFEOS_REPO
Vault:  $VAULT_PATH
Shell:  $SHELL_RC
──────────────────────────────────────────────────────────────────────────

Next steps:

1. Reload your shell
      source $SHELL_RC
   (or open a new terminal tab)

2. Authenticate Google Drive in Claude
   In any Claude Code session: /mcp → select Google Drive
   Grant write/edit permissions — not just read-only.

3. Spawn your first coach
      brain
   Then say: "spawn a cooking coach"  (or pole, thinking, fitness, speaking…)
   Each coach adds its own alias automatically when created.

4. Set up Claude.ai phone project per coach
   See _ai/claude-ai.md for step-by-step instructions.

5. (Recommended) Install Google Drive Desktop for full phone↔Mac sync
   https://www.google.com/drive/download/ — choose Mirror mode, not Stream.
   Then re-run this script to update your VAULT path to the Drive location.

Troubleshooting: SETUP.md → Troubleshooting section
──────────────────────────────────────────────────────────────────────────
NEXT
}

# ---------------------------------------------------------------------------
main() {
    log "LifeOS bootstrap starting..."
    log "Repo:  $LIFEOS_REPO"
    log "Vault: $VAULT_PATH"
    step_check_dependencies
    step_link_skills
    step_create_vault
    step_set_aliases
    step_init_caches
    step_print_next
}

main "$@"
