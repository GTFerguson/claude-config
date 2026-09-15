# Claude Code account profiles: an enterprise login for work, a personal one otherwise.
#
# The choice is made by shell/bin/claude, a launcher placed ahead of the real
# binary on PATH so that every way of starting Claude goes through it. See that
# script for how the profile is picked.

# Always move the launcher to the front, even if it is already on PATH. A shell
# started from another one (CADE's terminals) inherits a PATH that holds it, and
# ~/.bashrc then puts ~/.local/bin, where the real binary lives, back ahead of it.
__claude_launcher_dir="$HOME/.claude/shell/bin"
__claude_path=":$PATH:"
while case "$__claude_path" in *":$__claude_launcher_dir:"*) true ;; *) false ;; esac; do
    __claude_path="${__claude_path/:$__claude_launcher_dir:/:}"
done
__claude_path="${__claude_path#:}"
PATH="$__claude_launcher_dir:${__claude_path%:}"
export PATH
unset __claude_launcher_dir __claude_path

claude-work()     { CLAUDE_PROFILE=work claude "$@"; }
claude-personal() { CLAUDE_PROFILE=personal claude "$@"; }
