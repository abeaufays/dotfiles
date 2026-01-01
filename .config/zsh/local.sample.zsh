# Open a set of tmux session
if [ -x "$(command -v tmux)" ] && [ -z "$TMUX" ]; then
    tmux has-session -t config 2>/dev/null || tmux new -s config -c ~/.config -d
    tmux has-session -t main 2>/dev/null || tmux new -s main -d
    tmux attach -t main
fi
