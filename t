#!/usr/bin/env bash
# t [name] — attach to tmux session (default "Work") from any terminal.
#   no session yet      -> create it
#   session unattached  -> attach directly
#   session in use      -> grouped session: same windows, independent view.
#                          Auto-destroyed on detach; windows/processes survive.
set -euo pipefail

base="${1:-Work}"

if [[ -n "${TMUX:-}" ]]; then
  echo "t: already inside tmux (session: $(tmux display -p '#S'))" >&2
  exit 1
fi

if ! tmux has-session -t "=$base" 2>/dev/null; then
  exec tmux new-session -s "$base"
fi

attached="$(tmux list-sessions -f "#{==:#{session_name},$base}" -F '#{session_attached}')"
if [[ "$attached" == 0 ]]; then
  exec tmux attach-session -t "=$base"
fi

n=2
while tmux has-session -t "=$base-$n" 2>/dev/null; do n=$((n + 1)); done

exec tmux new-session -t "=$base" -s "$base-$n" \; set-option destroy-unattached on
