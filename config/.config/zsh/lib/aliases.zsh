# .zshrc reload
alias re="source ~/.zshrc"

# vim
function vi() {
  nvim ${=*/:/ +}
}
function vim() {
  nvim ${=*/:/ +}
}

function mkcd() {
  mkdir $1
  cd $1
}

alias d="direnv allow"
alias de="direnv edit"

if [[ $(uname) -eq "Darwin" ]]; then
  alias ll="ls -la"
else
  alias ll="ls -la --color=auto"
fi

alias l=ll
alias lll=ll

function cdr() {
  local d=$(git rev-parse --show-toplevel)
  cd $d
}
