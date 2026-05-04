#!/usr/bin/env bash
# bootstrap.sh — Initialize a new GetBetterAt vault on this Mac
# Run from anywhere; sets up vault structure, copies templates, configures shell.

set -euo pipefail

# ─── Configuration ──────────────────────────────────────────────────────────

DEFAULT_VAULT_PATH="$HOME/Documents/Vault"
GETBETTERAT_REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHELL_RC="${SHELL_RC:-$HOME/.zshrc}"

# ─── Helpers ────────────────────────────────────────────────────────────────

log()    { printf "\033[1;34m[bootstrap]\033[0m %s\n" "$*"; }
ok()     { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
warn()   { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err()    { printf "\033[1;31m[error]\033[0m %s\n" "$*" >&2; exit 1; }
prompt() { printf "\033[1;36m[?]\033[0m %s " "$*"; read -r REPLY; echo "$REPLY"; }

# ─── Steps ──────────────────────────────────────────────────────────────────

step_choose_vault_path() {
    log "Where should your vault live?"
    log "  Default: $DEFAULT_VAULT_PATH"
    log "  Tip: if Google Drive Desktop is installed, point at"
    log "       ~/Library/CloudStorage/GoogleDrive-<email>/My Drive/Vault"
    local custom
    custom=$(prompt "Press Enter for default, or type custom path:")
    if [[ -z "$custom" ]]; then
        VAULT_PATH="$DEFAULT_VAULT_PATH"
    else
        VAULT_PATH="$(eval echo "$custom")"
    fi
    log "Vault will be at: $VAULT_PATH"
}

step_create_vault_structure() {
    log "Creating vault structure..."

    mkdir -p "$VAULT_PATH/_shared"
    mkdir -p "$VAULT_PATH/Coaches"
    mkdir -p "$VAULT_PATH/Daily"
    mkdir -p "$VAULT_PATH/Ideas"
    mkdir -p "$VAULT_PATH/Projects"
    mkdir -p "$VAULT_PATH/Reading"
    mkdir -p "$VAULT_PATH/Archive/Coaches"
    mkdir -p "$VAULT_PATH/Archive/Daily"
    mkdir -p "$VAULT_PATH/.claude/skills"

    if [[ ! -f "$VAULT_PATH/Inbox.md" ]]; then
        cat > "$VAULT_PATH/Inbox.md" <<'EOF'
# Inbox

Append-only rapid capture. One line per item, with timestamp. Distilled periodically (run `idea-distill` skill) into proper homes.

Format: `- YYYY-MM-DD HH:MM — [item]`

---

EOF
        ok "Inbox.md created"
    fi

    ok "Vault directories created at $VAULT_PATH"
}

step_copy_templates() {
    log "Copying framework templates..."

    # Top-level CLAUDE.md
    if [[ ! -f "$VAULT_PATH/CLAUDE.md" ]]; then
        cp "$GETBETTERAT_REPO_PATH/templates/CLAUDE.md.template" "$VAULT_PATH/CLAUDE.md"
        ok "Top-level CLAUDE.md installed"
    else
        warn "$VAULT_PATH/CLAUDE.md already exists; skipping"
    fi

    # Shared files
    for f in profile.md principles.md schedule.md; do
        if [[ ! -f "$VAULT_PATH/_shared/$f" ]]; then
            cp "$GETBETTERAT_REPO_PATH/templates/_shared/$f" "$VAULT_PATH/_shared/$f"
            ok "_shared/$f installed"
        else
            warn "_shared/$f already exists; skipping"
        fi
    done

    # Skills
    cp -rn "$GETBETTERAT_REPO_PATH/skills/"* "$VAULT_PATH/.claude/skills/"
    ok "Agent Skills copied to .claude/skills/"

    # Empty drive-config (filled by spawn-coach later)
    if [[ ! -f "$VAULT_PATH/.claude/drive-config.json" ]]; then
        cat > "$VAULT_PATH/.claude/drive-config.json" <<'EOF'
{
  "_comment": "Drive folder IDs added by spawn-coach skill. Empty until first coach.",
  "vault_root_id": null,
  "shared_id": null,
  "meta_id": null,
  "coaches": {},
  "_processed_inbox_path": "~/.cache/vault-processed-inbox.json"
}
EOF
        ok "drive-config.json initialized (empty)"
    fi
}

step_setup_cache_files() {
    log "Initializing cache trackers..."
    mkdir -p "$HOME/.cache"

    if [[ ! -f "$HOME/.cache/vault-processed-inbox.json" ]]; then
        cat > "$HOME/.cache/vault-processed-inbox.json" <<'EOF'
{
  "version": 1,
  "_comment": "Tracks Drive inbox file IDs already processed by Mac Claude vault-pull-inbox skill.",
  "last_pull": null,
  "processed_ids": {}
}
EOF
        ok "vault-processed-inbox.json initialized"
    fi

    if [[ ! -f "$HOME/.cache/vault-last-maintenance.json" ]]; then
        cat > "$HOME/.cache/vault-last-maintenance.json" <<'EOF'
{
  "version": 1,
  "last_run": null,
  "actions_history": []
}
EOF
        ok "vault-last-maintenance.json initialized"
    fi
}

step_add_aliases() {
    log "Adding shell aliases to $SHELL_RC..."

    if grep -q "# GetBetterAt aliases" "$SHELL_RC" 2>/dev/null; then
        warn "Aliases already present in $SHELL_RC; skipping"
        return
    fi

    cat >> "$SHELL_RC" <<EOF

# GetBetterAt aliases — added by bootstrap.sh on $(date +%Y-%m-%d)
# Edit VAULT path below if you move the vault later.
export VAULT="$VAULT_PATH"
alias brain='cd "\$VAULT" && claude --dangerously-skip-permissions'
# Specific coach aliases get added by the spawn-coach skill.
EOF

    ok "Aliases added. Run 'source $SHELL_RC' or open a new terminal tab to activate."
}

step_print_next_steps() {
    cat <<EOF

──────────────────────────────────────────────────────────────────────────
✅ Bootstrap complete

Vault:        $VAULT_PATH
Framework:    $GETBETTERAT_REPO_PATH
Shell config: $SHELL_RC

────────── Next steps ──────────

1. Reload shell:   open a new terminal tab, OR:
                   source $SHELL_RC

2. Authenticate Drive in Claude Code:
                   In any 'brain' or 'claude' session, run /mcp
                   Select 'claude.ai Google Drive', complete OAuth.

3. Spawn your first coach:
                   In your terminal:    brain
                   In Claude:           "spawn a [domain] coach"
                                        e.g., "spawn a pole coach"

4. Set up Claude.ai phone Project:
                   The spawn-coach skill will print a system prompt.
                   Open Claude.ai (web or iOS), create new Project,
                   paste the system prompt, pin it.

5. (Recommended) Install Google Drive Desktop:
                   https://www.google.com/drive/download/
                   Choose "Mirror files" mode.
                   Then move vault into Drive folder and update VAULT
                   in $SHELL_RC.

For more detail: see SETUP.md in the framework repo.

──────────────────────────────────────────────────────────────────────────
EOF
}

# ─── Main ───────────────────────────────────────────────────────────────────

main() {
    log "GetBetterAt bootstrap starting..."

    if [[ ! -d "$GETBETTERAT_REPO_PATH" ]]; then
        err "Framework repo path not found at $GETBETTERAT_REPO_PATH"
    fi

    step_choose_vault_path
    step_create_vault_structure
    step_copy_templates
    step_setup_cache_files
    step_add_aliases
    step_print_next_steps
}

main "$@"
