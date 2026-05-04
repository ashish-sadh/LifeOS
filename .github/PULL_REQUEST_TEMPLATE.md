## What this PR does

<!-- One paragraph. What did you add, fix, or change? -->

## Why

<!-- What gap does this fill, or what bug does it fix?
     Link to an issue if applicable: Closes #123 -->

## Type

- [ ] New coach domain (`examples/<domain>/`)
- [ ] New skill (`skills/<name>/SKILL.md`)
- [ ] Skill improvement (clarification, edge case handling, algorithm fix)
- [ ] Bug fix
- [ ] Documentation
- [ ] Other: _______________

## Testing

<!-- How did you verify this works?
     For skills: describe the Mac CLI session where you tested it.
     For scripts: confirm bash -n passes and describe any manual test.
     For docs: describe what you checked for correctness. -->

## Checklist

- [ ] No personal data (real Drive IDs, real names, real session logs)
- [ ] No hardcoded paths (uses `$VAULT`, not a specific user's Drive path)
- [ ] Follows naming conventions (SKILL.md frontmatter, kebab-case files, etc.)
- [ ] `bash -n` passes for any `.sh` files added or modified
- [ ] If adding a new coach example: includes README explaining what's distinctive about the domain
- [ ] If adding a new skill: includes "When to invoke", algorithm, "Don't" section
