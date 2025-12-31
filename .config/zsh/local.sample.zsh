# Open a set of tmux session
if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then
    tmux new-session -d -s config -c ~/.config >/dev/null 2>&1
    exec tmux new-session -A -s main-project -c ~/projects/main-project/ >/dev/null 2>&1
fi
