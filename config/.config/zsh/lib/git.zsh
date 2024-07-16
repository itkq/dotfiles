alias gci="git commit -v -S"
alias gcim="git commit -v -S -m"
alias gm="git merge"
alias gst="git status"
alias gco="git checkout"
alias gbr="git branch"
alias ga="git add"
alias gaa="ga -A"
alias gf="git fetch"
alias gd="git diff --word-diff=color"
alias gignore="git rm -r --cached .; git add ."
alias gca="git commit -v -S --amend"
alias gcan="git commit -S --amend --no-edit"
alias current-branch='git rev-parse --abbrev-ref HEAD'

function gl(){
  if [ $# -ne 0 ]; then
    git log --date=iso --pretty=format:'%h %Cgreen%ad %Cblue%an %Creset%s %C(blue)%d%Creset' $@
  else
    git log --date=iso --pretty=format:'%h %Cgreen%ad %Cblue%an %Creset%s %C(blue)%d%Creset' -10
  fi
}

# git push to current branch with remote fallback
function gp() {
  if [ $# -ne 0 ]; then
    # if origin is http://github.com/foo/bar, change to github.com:foo/bar
    if git remote | grep -q origin; then
      remote=`git config --get remote.origin.url`

      if echo $remote | grep -q "^https://"; then
        new_remote=`echo $remote | sed -e "s/https:\/\/github\.com\//github.com:/g"`

        git remote rm origin
        git remote add origin $new_remote
      fi
    fi

    # check whether remote mine exists or not
    mine_push=false
    for arg in $@; do
      if [ $arg = "mine" ]; then
        mine_push=true
      fi
    done

    # if mine does not exist, push to origin
    if $mine_push; then
      if git remote | grep -q mine; then
        git push $@ `current-branch`
      else
        git push `echo $@ | sed -e "s/mine/origin/"` `current-branch`
      fi
    else
      git push $@ `current-branch`
    fi
  else
    if git remote show origin | grep -q `current-branch`; then
      git push
    else
      echo "\e[33mSet upstream `current-branch`\e[m"
      git push --set-upstream origin `current-branch`
    fi
  fi
}

function gpf() {
  current_dir=$(git rev-parse --show-toplevel)
  remote_url=$(git remote get-url --push origin)
  echo "\e[33m[Warning] You are trying force pushing\e[m"
  echo "  from: $current_dir:`current-branch`"
  echo "    to: $remote_url:`current-branch`"
  read Answer\?'Are you sure? [Y/n] '
  case $Answer in
    '' | [Yy]* )
      git push --force-with-lease origin `current-branch`
      ;;
    * )
      echo "Force pushing interrupted."
      return 1
      ;;
  esac
}

alias gpp='gp && open_pr'

function open_pr() {
  open "https://github.com/$(current-repo)/pull/new/$(current-branch)"
}


function gup(){
  local stash_flg=0
  local change_branch_flg=0
  [ -z "$(git status --short)" ] || (git stash push -u -q && stash_flg=1)
  local base_branch="master"
  if $(git branch -a | grep -q remotes/origin/develop); then
    base_branch="develop"
  elif $(git branch | grep -q main); then
    base_branch="main"
  fi;

  [ "$(__current_branch)" != $base_branch ] && git checkout $base_branch && change_branch_flg=1

  if git remote | grep -q upstream; then
    git fetch upstream
    git rebase upstream/$base_branch
  else
    git fetch origin
    git rebase origin/$base_branch
  fi
  git branch -vv | grep ': gone]' | grep -v '\*' | awk '{ print $1 }' | xargs -r git branch -D

  (( $change_branch_flg )) && git checkout -
  (( $stash_flg )) && git stash pop
  true
}

function gc() {
  git clean -fd
  if [ "$(pwd)" != "$(git rev-parse --show-toplevel)" ]; then
    pushd $(git rev-parse --show-toplevel)
    git checkout -- .
    popd
  else
    git checkout -- .
  fi
}

function gha_browse() {
  repo=$(git rev-parse --show-toplevel | awk -F'/' -v OFS='/' '{print $(NF-1), $NF}')
  find $(git rev-parse --show-toplevel)/.github/workflows -exec basename {} + | grep -vE '^_' | sort | peco | xargs -I%% open "https://github.com/$repo/actions/workflows/%%"
}
