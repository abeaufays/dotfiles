source ~/.config/zsh/prompt
source ~/.config/zsh/alias
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

# export LS_COLORS="$(vivid generate jellybeans)"
alias ls=' ls --color=auto'
alias grep='grep --color=auto'

alias dgit='git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'

export LC_ALL=C.UTF-8    

export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

if [ -f ~/.config/zsh/local ]; then
    source ~/.config/zsh/local
fi
