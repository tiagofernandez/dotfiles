# http://ridiculousfish.com/shell/user_doc/html/

# Change the greeting message
set fish_greeting 'Unleash your awesomeness!'

# Set Sublime Text as default editor
set -gx EDITOR subl
set -gx VISUAL subl

# Define bin path variables
set postgresql /Library/PostgreSQL/9.3/bin
set mongodb $HOME/Toolbox/mongodb-osx-x86_64-2.4.7/bin
set heroku /usr/local/heroku/bin
set groovy /usr/local/Cellar/groovy/2.1.8/bin
set npm /usr/local/share/npm/bin
set pyenv $HOME/.pyenv/versions/2.7.5/bin $HOME/.pyenv/shims
set rvm $HOME/.rvm/bin

# Define the path
set -gx PATH $rvm $pyenv $npm $groovy $heroku $mongodb $postgresql $PATH

# Configure Git's prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# Customize the default prompt
function fish_prompt
	set last_status $status
	set_color $fish_color_cwd
	printf '%s' (prompt_pwd)
	set_color normal
	printf '%s ' (__fish_git_prompt)
	set_color normal
end

# Utility to reload the configuration
function reload_fish
  . $HOME/.config/fish/config.fish
  echo "Fish configuration reloaded."
end

# Initialize Pyenv
. (pyenv init - | psub)

# Show hidden files by default
alias ls='ls -a'
