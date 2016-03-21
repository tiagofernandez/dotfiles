# Load the individual per-interactive-shell startup file
if [ -f ~/.bashrc ]; then source ~/.bashrc ; fi

# Command line
export PS1='\w `git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\[\033[37m\]$\[\033[00m\] '
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"
export EDITOR='subl -w'

# Homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Aliases
alias ls="ls -a"
