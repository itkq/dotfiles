# https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
wattach-workspace() {
  printf "\033]1337;SetUserVar=%s=%s\007" hacky-user-command $(printf '{"cmd":"attach-workspace","title":"%s"}' $1 | base64)
}
wset-workspace-title() {
  printf "\033]1337;SetUserVar=%s=%s\007" hacky-user-command $(printf '{"cmd":"set-workspace-title","title":"%s"}' $1 | base64)
}

function create-session() {
  if [ $# -ne 0 ]; then
    target_dir=$1
  else
    target_dir='.'
  fi
  target_dir=$(cd $target_dir; pwd)
  session_name=$(echo $target_dir | grep -o "[^/]*/[^/]*$")

  # switch or create session
  if wezterm cli list --format json | jq -r '.[].workspace' | sort - | grep -q $session_name; then
    wattach-workspace $session_name
    return
  fi
  # FIXME: this doesn't move cwd
  wezterm cli spawn --new-window --workspace $session_name --cwd $target_dir
  wattach-workspace $session_name
}
alias cs="create-session"

# https://vrongmeal.com/blog/clear-screen-preserve-buffer
my-clear() {
  for i in {3..$(tput lines)}
  do
    printf '\n'
  done
  zle clear-screen
}
zle -N my-clear
bindkey '^L' my-clear
