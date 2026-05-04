# Ralph Agent Configuration for LifeOS

## Build Instructions

LifeOS is a markdown + shell scripts framework. There is no compile/build step.

```bash
# Validate shell scripts
bash -n scripts/bootstrap.sh
bash -n .claude/scheduled/*.sh

# Optional: shellcheck if installed
command -v shellcheck > /dev/null && shellcheck scripts/*.sh .claude/scheduled/*.sh
```

## Test Instructions

```bash
# Smoke tests (manual)
# 1. Verify all SKILL.md files have valid frontmatter
for f in skills/*/SKILL.md; do
    head -5 "$f" | grep -q '^---' || echo "Missing frontmatter: $f"
done

# 2. Verify markdown links are sensible
# (no automated test framework yet)

# 3. Verify bootstrap.sh syntax
bash -n scripts/bootstrap.sh

# 4. Check that all examples/<domain>/ folders have at least README.md and CLAUDE.md
for d in examples/*/; do
    [ -f "$d/README.md" ] || echo "Missing README.md: $d"
done
```

No formal unit test framework is set up. Tests are manual / lightweight by design — this is a markdown framework.

## Run Instructions

There's no "running" the framework directly. It's installed via `scripts/bootstrap.sh` into a user's environment.

To verify the bootstrap works:

```bash
# Dry-run check (don't actually run on this machine; framework is already installed here)
cat scripts/bootstrap.sh | head -50  # review what it does
```

## Notes

- This is a personal AI knowledge OS framework — markdown + shell scripts only
- No build/compile step
- Tests are intentionally minimal; the framework is content-heavy, not code-heavy
- Ralph should focus on content quality (skills, examples, docs) not test infrastructure
