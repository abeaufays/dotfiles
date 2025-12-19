source ~/projects/shared_config/zsh/prompt
source ~/projects/shared_config/zsh/alias
export PATH="~/projects/shared_config/scripts/bin:$PATH"
source <(fzf --zsh)

HISTFILE=~/.histfile
HISTSIZE=1000
setopt HIST_IGNORE_SPACE
SAVEHIST=1000

bindkey -e
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

# UV install
. "$HOME/.local/bin/env"

export LS_COLORS="$(vivid generate jellybeans)"
alias ls=' ls --color=auto'
alias grep='grep --color=auto'

alias dotfiles='git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'

export LC_ALL=C.UTF-8    

export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
