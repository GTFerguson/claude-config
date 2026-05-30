# CADE handoff auto-resume for Claude Code.
#
# When an interactive `claude` session exits and the project has a freshly
# written handoff brief (docs/plans/handoff/<slug>.md, from the /handoff skill),
# relaunch claude in the SAME terminal seeded with a prompt telling it to read
# the brief and resume. The brief path is submitted as the first user turn, so
# the new session starts working immediately — no copy-paste, no /clear, no
# reopening. Resumes once per /handoff (a marker stops it re-firing when you
# just want to quit) and only for recent briefs (so a day-old handoff doesn't
# ambush a cold open).

CADE_RESUME_WINDOW="${CADE_RESUME_WINDOW:-1800}"   # brief must be newer than this many seconds

# Per-project marker recording the last brief we auto-resumed. Lives outside the
# repo (keyed by a hash of the project path) so it never pollutes git.
__cade_marker() {
    local dir="$HOME/.cache/cade-resume"
    mkdir -p "$dir" 2>/dev/null
    printf '%s/%s' "$dir" "$(printf '%s' "$PWD" | cksum | cut -d' ' -f1)"
}

# Newest handoff brief under the current dir (excluding a README index), or "".
__cade_latest_brief() {
    find "$PWD/docs/plans/handoff" -maxdepth 1 -type f -name '*.md' ! -iname 'readme.md' \
        -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-
}

# Echo a brief to auto-resume, or nothing. Applies the freshness + single-shot
# guards so this is silent in every project that isn't mid-handoff.
__cade_resume_brief() {
    [ -d docs/plans/handoff ] || return 0
    local brief
    brief=$(__cade_latest_brief)
    [ -n "$brief" ] || return 0

    local now bmt
    now=$(date +%s)
    bmt=$(stat -c %Y "$brief" 2>/dev/null) || return 0
    [ $((now - bmt)) -le "$CADE_RESUME_WINDOW" ] || return 0   # too old -> ignore

    local marker mmt=0
    marker=$(__cade_marker)
    [ -f "$marker" ] && mmt=$(stat -c %Y "$marker" 2>/dev/null || echo 0)
    [ "$bmt" -gt "$mmt" ] || return 0                          # already resumed this brief

    printf '%s\n' "$brief"
}

# Relaunch into the brief for as long as a fresh, unresumed handoff exists.
# Touching the marker BEFORE launching caps this at one relaunch per /handoff,
# so a crash-on-start or an immediate exit can't spin.
__cade_resume_loop() {
    local brief
    while brief=$(__cade_resume_brief); [ -n "$brief" ]; do
        touch "$(__cade_marker)"
        clear 2>/dev/null
        command claude "Read $brief and resume the work it describes, following its Contract section."
    done
}

# Wrap `claude` so CADE's auto-typed `claude` (and plain terminal use) gain
# auto-resume. `command claude` reaches the real binary without re-entering this.
claude() {
    command claude "$@"
    local code=$?
    # Only resume real interactive TUI sessions - never -p/--print or piped/script use.
    case " $* " in *" -p "*|*" --print "*) return "$code";; esac
    [ -t 0 ] && [ -t 1 ] || return "$code"
    __cade_resume_loop
    return "$code"
}

# Manual trigger: resume the latest handoff on demand (ignores the freshness window).
resume() {
    local brief
    brief=$(__cade_latest_brief)
    if [ -z "$brief" ]; then
        echo "No handoff brief found in docs/plans/handoff/." >&2
        return 1
    fi
    touch "$(__cade_marker)"
    clear 2>/dev/null
    command claude "Read $brief and resume the work it describes, following its Contract section."
}
