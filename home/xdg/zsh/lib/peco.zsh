# global aliases
alias -g B='`git branch | peco | sed -e "s/^\*[ ]*//g"`'
alias -g P='| peco | xargs '

if ! which peco > /dev/null; then
	return
fi

# history
function peco-select-history() {
	BUFFER=$(fc -l -r -n 1 | peco --query "$LBUFFER" --prompt "[zsh history]")
	CURSOR=$#BUFFER
	zle redisplay
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# integrate all source code with ghq
function peco-src() {
	local selected_dir=$(ghq list --vcs git | peco --query "$LBUFFER" --prompt "[ghq list]")
	if [ -n "$selected_dir" ]; then
		full_dir="${GOPATH}/src/${selected_dir}"

		# Log repository access to ghq-cache
		# (ghq-cache log $full_dir &)

		BUFFER="cd ${full_dir}"
		zle accept-line
	fi
	zle redisplay
}
zle -N peco-src
stty -ixon
bindkey '^s' peco-src

# search file recursively and append the path to the buffer
function peco-find-file() {
	if git rev-parse 2> /dev/null; then
		source_files=$(git ls-files)
	else
		source_files=$(find . -type f)
	fi
	selected_files=$(echo $source_files | peco --prompt "[find file]")

	BUFFER="${BUFFER}$(echo $selected_files | tr '\n' ' ')"
	CURSOR=$#BUFFER
	zle redisplay
}
zle -N peco-find-file
bindkey '^g' peco-find-file
