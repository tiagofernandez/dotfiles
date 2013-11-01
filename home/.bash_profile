# Load the individual per-interactive-shell startup file
if [ -f ~/.bashrc ]; then source ~/.bashrc ; fi

# Command line
export PS1='\w `git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\[\033[37m\]$\[\033[00m\] '
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"
export EDITOR='subl -w'

# Paths
export HEROKU_HOME=/usr/local/heroku
export GROOVY_HOME=/usr/local/Cellar/groovy/2.1.8
export NPM_HOME=/usr/local/share/npm
export PYTHONHOME=$HOME/.pyenv/versions/2.7.5
export RVM_HOME=$HOME/.rvm
export POSTGRESQL_HOME=/Library/PostgreSQL/9.3
export MONGODB_HOME=$HOME/Toolbox/mongodb-osx-x86_64-2.4.7
export PATH=$RVM_HOME/bin:$PYTHONHOME/bin:$GROOVY_HOME/bin:$NPM_HOME/bin/:$POSTGRESQL_HOME/bin:$MONGODB_HOME/bin:$HEROKU_HOME/bin:$PATH

# Homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
source ~/.pyenv/versions/2.7.5/bin/virtualenvwrapper.sh

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Aliases
alias ls="ls -a"
