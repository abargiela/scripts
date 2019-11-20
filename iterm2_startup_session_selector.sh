#!/bin/bash

# Usage: In `Profiles -> General -> Command ` choose: `login shell` and add the path where this script is: `bash ~/iterm2_startup_session_selector.sh`

TMUX_OPENED_SESSIONS=$(tmux ls |wc -l|awk '{print $1}')

if [[ $TMUX_OPENED_SESSIONS > 1 ]]; then
    clear
    tmux list-sessions -F '#S'
    echo "Type in which session connect:"
    read SESSION_NAME
    tmux attach -t $SESSION_NAME
elif [[ $TMUX_OPENED_SESSIONS < 1 ]]; then
    clear
    echo 'You do not have any TMUX active sessions, please create one, give a name and hit enter.'
    read NO_SESSIONS_YET
    tmux new -s $NO_SESSIONS_YET
else
    clear
    tmux attach
fi

