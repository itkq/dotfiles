# language
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000000
export HISTFILESIZE=100000
export SAVEHIST=60000000

setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt ignore_eof # don't logout by EOF
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_no_store

setopt no_beep

# emacs key bind
bindkey -e

export GTAGSLABEL=pygments

# aqua
export AQUA_GLOBAL_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
export AQUA_POLICY_CONFIG=$XDG_CONFIG_HOME/aquaproj-aqua/aqua-policy.yaml
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
aqua i -l -a

alias ls="ls --color=auto"

# direnv
export EDITOR=nvim
eval "$(direnv hook zsh)"

