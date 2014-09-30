# http://fishshell.com/docs/current/index.html
# http://ridiculousfish.com/shell/user_doc/html/

# Suppress the greeting message
set fish_greeting ''

# Set Sublime Text as default editor
set -gx EDITOR subl
set -gx VISUAL subl

# Define bin path variables
set postgresql /Library/PostgreSQL/9.3/bin
set mongodb $HOME/Toolbox/mongodb-osx-x86_64-2.4.7/bin
set heroku /usr/local/heroku/bin
set groovy /usr/local/Cellar/groovy/2.1.8/bin
set npm /usr/local/share/npm/bin
set rvm $HOME/.rvm/bin

# Define the path
set -gx PATH $rvm $npm $groovy $heroku $mongodb $postgresql $PATH

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

# Configure Docker
set -gx DOCKER_HOST 'tcp://:2375'
alias docker_rm_all='docker rm (docker ps -a -q)'
alias docker_rmi_all='docker rmi (docker images -q)'

# Customize the default prompt
function fish_prompt
  set last_status $status
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  if set -q VIRTUAL_ENV
    set_color magenta
    printf ' (%s)' (basename "$VIRTUAL_ENV")
  end
  set_color normal
  printf '%s ' (__fish_git_prompt)
  set_color normal
end

# Initialize Pyenv
. (pyenv init - | psub)

# Initialize VirtualFish
. $HOME/.config/fish/virtualfish/virtual.fish
. $HOME/.config/fish/virtualfish/global_requirements.fish

function pip_uninstall_all --description='Uninstall all Python packages.'
  pip freeze | grep -v "^-e" | xargs pip uninstall -y
end

# Initialize RVM
set rvm_project_rvmrc 1
. $HOME/.config/fish/functions/rvm.fish

function gem_uninstall_all --description='Uninstalls all Ruby gems.'
  for each in (gem list --no-version)
    sudo gem uninstall -aIx $each
  end
end

function reload_fish --description='Reloads the Fish configuration.'
  . $HOME/.config/fish/config.fish
  echo "Fish configuration reloaded."
end

function source_bash --description='Sources a Bash script.'
  exec /bin/bash -c "source $argv && exec fish"
end

function search_class --description='Searches for class in file system of jars.'
  find -name \*.jar | xargs -n1 -iFILE sh -c "jar tvf FILE | sed -e s#^#FILE:#g" | grep $argv\\.class | cut -f1 -d:
end

function ip_internal --description='Displays the internal IP.'
  ifconfig | grep -v 127.0.0.1 | sed -En 's/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
end

function ip_external --description='Displays the external IP.'
  curl icanhazip.com
end

# Show hidden files by default
alias ls='ls -a'

# Set useful variables
set -gx INTERNAL_IP (ip_internal)

# Run last command as root
alias fuck='sudo $history[1]'
