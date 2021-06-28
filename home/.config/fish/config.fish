# http://fishshell.com/docs/current/index.html
# http://ridiculousfish.com/shell/user_doc/html/

# Greeting message
set fish_greeting ''

# VirtualFish
. $HOME/.config/fish/virtualfish/virtual.fish
. $HOME/.config/fish/virtualfish/global_requirements.fish

# Default editor
set -gx EDITOR vim
set -gx VISUAL vim

# Go
set -gx GOPATH $HOME/Work/go
set -gx PATH $PATH $GOPATH/bin

# Kubernetes
alias k='kubectl'

# Java
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk-14.0.1.jdk/Contents/Home/

# NVM
set -gx NVM_DIR $HOME/.nvm

function nvm
  bass source $HOME/.nvm/nvm.sh --no-use ';' nvm $argv
end

nvm use default >/dev/null 2>&1

# Python
pyenv init - | source

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

# Unsets an env variable
alias unset 'set --erase'

# Renames JPEG files according to their creation dates
function rename_jpg
  bash -c 'for i in *.jpg; do newname=$(stat -t %Y%m%d%H%M%S -f %Sm -- $i); mv -- $i $newname.jpg; done'
end

# Show hidden files by default
alias ls='ls -la'

# Run last command as root
alias please='eval command sudo $history[1]'

# Starship prompt
starship init fish | source
