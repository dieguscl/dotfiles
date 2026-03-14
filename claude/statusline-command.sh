#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
printf "%s@%s:%s" "$(whoami)" "$(hostname -s)" "$cwd"
