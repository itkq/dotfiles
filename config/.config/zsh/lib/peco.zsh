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
	local cache_file="${HOME}/.cache/ghq-list-cache"
	local cache_time=3600  # 1時間

	# キャッシュディレクトリ作成
	mkdir -p "$(dirname "$cache_file")"

	# キャッシュが古い、または存在しない場合は更新
	if [[ ! -f "$cache_file" ]] || [[ $(($(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || echo 0))) -gt $cache_time ]]; then
		ghq list > "$cache_file"
	fi

	local selected_dir=$(cat "$cache_file" | peco --query "$LBUFFER" --prompt "[ghq list]")
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
