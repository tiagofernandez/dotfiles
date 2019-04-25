# http://fishshell.com/docs/current/index.html
# http://ridiculousfish.com/shell/user_doc/html/

# Greeting message
set fish_greeting ''

# Fish prompt
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

# VirtualFish
. $HOME/.config/fish/virtualfish/virtual.fish
. $HOME/.config/fish/virtualfish/global_requirements.fish

# Default editor
set -gx EDITOR vim
set -gx VISUAL vim

# Git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# Docker
alias docker_rm_all='docker rm (docker ps -a -q)'
alias docker_rm_clean='docker ps -a | egrep "weeks ago|months ago" | awk "{print $1}" | xargs --no-run-if-empty docker rm'
alias docker_rmi_all='docker rmi (docker images -q)'
alias docker_rmi_clean='docker images | awk "/^<none>/ {print $3}" | xargs docker rmi'

# Java
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home/

# Python
source ~/.config/fish/autoenv.fish

function pip_uninstall_all --description='Uninstall all Python packages.'
  pip freeze | grep -v "^-e" | xargs pip uninstall -y
end

# Ruby
function gem_uninstall_all --description='Uninstalls all Ruby gems.'
  for each in (gem list --no-version)
    sudo gem uninstall -aIx $each
  end
end

# Zlib
set -gx LDFLAGS "$LDFLAGS -L/usr/local/opt/zlib/lib"
set -gx CPPFLAGS "$CPPFLAGS -I/usr/local/opt/zlib/include"
set -gx PKG_CONFIG_PATH "$PKG_CONFIG_PATH /usr/local/opt/zlib/lib/pkgconfig"

# Reloads the Fish configuration
function reload_fish
  . $HOME/.config/fish/config.fish
  echo "Fish configuration reloaded."
end

# Sources a Bash script
function source_bash
  exec /bin/bash -c "source $argv && exec fish"
end

# Sources an env file
function source_env
  for i in (cat $argv)
    set arr (echo $i |tr = \n)
    set arr_length (count $arr)
    if [ $arr_length = 2 -a (string sub --length 1 $arr[1]) != "#" ]
      set -gx $arr[1] $arr[2]
    end
  end
end

# Searches for class in file system of jars
function search_class
  find -name \*.jar | xargs -n1 -iFILE sh -c "jar tvf FILE | sed -e s#^#FILE:#g" | grep $argv\\.class | cut -f1 -d:
end

# Displays the internal IP
function ip_internal
  ifconfig | grep -v 127.0.0.1 | sed -En 's/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
end

# Displays the external IP
function ip_external
  curl icanhazip.com
end

# Creates a directory and enters it
function mkcd
  mkdir -p $argv
  cd $argv
end

# Renames JPEG files according to their creation dates
function rename_jpg
  bash -c 'for i in *.JPG; do newname=$(stat -t %Y%m%d%H%M%S -f %Sm -- $i); mv -- $i $newname.jpg; done'
end

# Show hidden files by default
alias ls='ls -a'
alias ll='ls -la'

# Set useful variables
set -gx INTERNAL_IP (ip_internal)

# Unleash the party parrot!
alias parrot='curl http://parrot.live'

# Run last command as root
alias fuck='eval command sudo $history[1]'
