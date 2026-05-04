# Writing Coach Example

Template for a creative writing coach. Use this as the starting point when spawning a `GetBetterAtWriting` coach.

## What's distinctive about this domain

- **Voice as a first-class file**: writing is the only domain with a centralized `voice.md` — a living document of what makes this writer's writing theirs. Every other domain tracks skills or knowledge. Writing tracks identity.
- **Pieces live through drafts**: unlike fitness (log sessions) or cooking (log recipes), a piece of writing is worked over time. The `pieces/` file for a single essay might be touched 5 times over 3 months. It's a longitudinal record of one piece of work, not a log of many sessions.
- **Coach reads the work, not just about the work**: the coach looks at actual prose when giving feedback. This requires actual text in the pieces/ files — not just metadata.
- **The coach does not write for the user**: this is the hardest boundary in this domain. The coach suggests structural moves, asks diagnostic questions, names what's working. The words are always the user's.
- **Different from cooking**: cooking tracks accumulating technical knowledge (recipes, techniques). Writing tracks developing voice across a body of work. The shape is similar (canonical file per artifact, patterns file) but the content is fundamentally different.

## Distinctive folder structure

```
Coaches/GetBetterAtWriting/
├── CLAUDE.md
├── profile.md
├── voice.md                      Centralized: what makes this writing theirs
├── pieces/                       One file per piece, across all its drafts
│   ├── 2026-09-12-the-last-apartment.md
│   ├── 2026-08-01-short-story-draft.md
│   └── ...
├── feedback/                     External feedback from readers, editors, workshop
│   └── 2026-09-10-workshop-notes.md
├── sessions.md                   Coach conversations
└── context-snapshot.md
```

## What to seed when spawning

The `spawn-coach` skill will ask:

1. What do you write? (Form: essays, fiction, poetry, non-fiction, hybrid)
2. Who are you writing for? (Yourself, literary readers, professional context, no audience yet)
3. What's your history with writing? (Years, volume, anything published or shared)
4. What brings you to a writing coach now? (Specific piece, voice development, finishing more, understanding feedback)
5. What's the piece you've abandoned most often? (Diagnostic for where you get stuck)
6. What's a piece of your writing you're proud of? (Baseline for voice work)
7. How do you take external feedback? (Receptive / defensive / depends on source)
8. Publication goal? (Active submission / building toward it / writing for self)

## Piece file format

Each piece in `pieces/` tracks one piece of writing across all its drafts:

```markdown
# [Title]

**Form**: <essay / story / etc.>
**Draft**: <number>
**Word count**: <n> (target: <range>)
**Status**: <drafting / stuck / revising / done>
**Intended audience**: <who>
**Submission target**: <where, if applicable>

## Working premise
<One paragraph on what the piece is trying to do and what's not working yet.>

## Draft excerpt (opening or key passage)
<The actual text — not a description of it.>

## What changed draft to draft
<Specific: what was cut, what was added, what's still broken.>

## Revision notes
<Open problems and what's working. Honest.>

## Feedback received
<Verbatim where possible. Coach's verdict on the feedback.>

## Coach notes
<Added by coach after reviewing. Specific to this piece, cross-linked to voice.md.>
```

The piece file is the primary working document — more important than sessions.md for this domain. The coach reads the actual draft, not just the metadata.

## Voice file conventions

`voice.md` is built over time, not filled in at spawn. The coach adds to it after reading 3+ pieces and identifying a reliable pattern. Entries should be:

- **Evidenced**: "appears in 4 of 6 pieces" not "tends to"
- **Specific**: "opens paragraphs with concrete physical detail before moving to abstraction" not "good at imagery"
- **Bifurcated**: separate sections for signatures (what to lean into) and tics (what to watch)
- **Timestamped**: each entry dated so the coach can track what's improved

Voice entries for tics should wait for 3+ appearances. One bad paragraph isn't a pattern.

## Tips

1. **Share actual prose, not descriptions of it**. The coach can't usefully respond to "I wrote a paragraph about loss." Paste the paragraph.
2. **The pieces/ file is the primary artifact**. Sessions.md records conversations; pieces/ records the actual work. Prioritize keeping pieces/ current.
3. **Let voice.md accumulate slowly**. Don't try to fill it at spawn. Let the coach build it from reading your work over 3–5 pieces.
4. **One piece of feedback at a time**. When sharing workshop feedback, the coach helps triage it — but not all at once. Start with the feedback that's most disorienting.
5. **Revision and drafting are different modes**. Tell the coach which mode you're in. Structural feedback on a near-final draft is frustrating; line-level feedback on a first draft is premature.
