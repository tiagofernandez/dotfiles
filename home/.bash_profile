export PS1='\w `git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\[\033[37m\]$\[\033[00m\] '
export MANPATH=/opt/local/share/man:$MANPATH
export EDITOR='mate -w'

export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

export VIM_APP_DIR=/Applications/MacVim-ppc-i386-10_5-7_3-53/

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

alias ls="ls -a"

source ~/.pythonbrew/etc/bashrc
source ~/.rvm/scripts/rvm
