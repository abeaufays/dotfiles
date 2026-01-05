source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/alias.zsh
export PATH="~/.config/scripts:$PATH"
source <(fzf --zsh)

HISTFILE=~/.histfile
HISTSIZE=1000
setopt HIST_IGNORE_SPACE
SAVEHIST=1000

bindkey -e
zstyle :compinstall filename '~/.zshrc'
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
