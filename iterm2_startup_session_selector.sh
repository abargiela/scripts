#!/bin/bash
# Usage: In `Profiles -> General -> Command ` choose: `login shell` and add the path where this script is: `bash ~/iterm2_startup_session_selector.sh`
TMUX_OPENED_SESSIONS=$(tmux ls |wc -l|awk '{print $1}')

if [[ $TMUX_OPENED_SESSIONS > 1 ]]; then
    tmux list-sessions -F '#S'
    echo "Type in which session connect:"
    read SESSION_NAME
    tmux attach -t $SESSION_NAME
else
    tmux attach
fi
