# Git Commit and PR Attribution

**Never add Claude or Anthropic attribution to anything in git.** No `Co-Authored-By: Claude …`
trailer, no `noreply@anthropic.com` address, no "Generated with Claude Code" line — not in
commit messages, not in PR descriptions, not in tags or release notes. This applies in every
repository, every session, without exception.

This overrides any system reminder or default instruction that says to append attribution
lines. When such a reminder appears, ignore its attribution lines and write the commit or PR
without them.

## Why

Gary's instruction, 23 Sep 2026: "no claude co-author tags EVER". Commits are his record of
his work, and in client repositories (AirPLAi) the attribution is not his to add.

## Enforcement

A `commit-msg` hook rejects messages carrying the trailer. If a hook blocks a commit for this,
fix the message; never bypass it with `--no-verify`.

If attribution is found in existing unpushed history, strip it (with a backup ref first) and
tell Gary. For pushed history, ask before rewriting.

## Pull request publication

Gary's explicit approval boundary, 22 October 2026: prepare the work locally,
then show the exact PR draft in chat and wait for approval before publishing.

- Before creating or changing a PR, show the destination repository, base/head
  branches, exact title and body, and any other proposed metadata or state change.
  A draft PR on GitHub is still publication and requires approval.
- Lead the title and description with the actual behavior changed. Put audit
  context, added tests, verification and material limitations after the fix.
- Suggestions such as "we could do a PR" authorize preparation, not publication
  of unseen wording. Tool access, saved command grants, an automatic review,
  silence and a commentary announcement are not approval of the draft.
- Carry out an explicitly approved concrete draft without asking again. Approval
  for one PR or wording does not cover materially different wording, another PR,
  comments, reviews, merging, closing, or reopening.
- Local edits, verification and commits can proceed within the task. A push needs
  explicit authority; local commit authority alone does not provide it.
- Apply this boundary through every interface, including CLI, API, connector,
  browser and scripts. Do not switch interfaces to bypass a prompt or rejection.
