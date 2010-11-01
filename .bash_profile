export PS1='\w `git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\[\033[37m\]$\[\033[00m\] '
export MANPATH=/opt/local/share/man:$MANPATH
export EDITOR='mate -w'

export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

export VIM_APP_DIR=/Applications/MacVim-ppc-i386-10_5-7_3-53/
export CELLAR_DIR=/usr/local/Cellar

export PYTHON_DIR=$CELLAR_DIR/python/2.7
export RUBY_DIR=$CELLAR_DIR/ruby/1.9.2-p0

export PATH=$PYTHON_DIR/bin:$PATH
export PATH=$RUBY_DIR/bin:$PATH

alias ls="ls -a"