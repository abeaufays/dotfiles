eval "$(starship init zsh)"
source ~/.config/zsh/alias.zsh
export PATH="~/.config/scripts:$PATH"
source <(fzf --zsh)

HISTFILE=~/.histfile
HISTSIZE=1000
setopt HIST_IGNORE_SPACE
SAVEHIST=1000

autoload -Uz compinit
compinit

export EDITOR=nvim

alias ls=' ls --color=auto'
alias grep='grep --color=auto'
alias vim=nvim

alias dgit='git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'

if [ -f ~/.config/zsh/local.zsh ]; then
    source ~/.config/zsh/local.zsh
fi

bindkey -v 

# Switch cursor on normal / insert mode
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      echo -ne '\e[2 q' ;; # Steady Block
    viins|main) echo -ne '\e[6 q' ;; # Steady Bar
  esac
}
zle -N zle-keymap-select

precmd() { echo -ne '\e[6 q' }
