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
