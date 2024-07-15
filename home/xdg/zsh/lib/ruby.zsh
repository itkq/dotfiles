# rbenv
eval "$(rbenv init - --no-rehash zsh)"

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"

# bundler
alias b="bundle"
alias be="bundle exec"

# bundle open
export BUNDLER_EDITOR="nvim"

export DISABLE_SPRING=1
