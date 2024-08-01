alias ll="ls -lah"

# https://brew.sh/
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="clean"

# Command execution timestamp in history ("mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd").
HIST_STAMPS="yyyy-mm-dd"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  brew
  docker
  docker-compose
  dotenv
  fzf
  git
  zsh-autosuggestions
  zsh-nvm
  zsh-syntax-highlighting
)

# Fix zsh-syntax-highlighting's paste performance.
# https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Preferred editor for local and remote sessions.
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="vim" # subl
fi

# https://github.com/junegunn/fzf?tab=readme-ov-file#-
eval "$(fzf --zsh)"

# Use https://github.com/sharkdp/fd instead of the default find for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# https://github.com/ohmyzsh/ohmyzsh#readme
source $ZSH/oh-my-zsh.sh

# https://starship.rs/guide/
eval "$(starship init zsh)"

# https://github.com/pyenv/pyenv#readme
eval "$(pyenv init --path)"

# https://opensource.apple.com/source/zsh/zsh-65/zsh/Functions/Misc/add-zsh-hook.auto.html
autoload -U add-zsh-hook

# https://github.com/moovweb/gvm#readme
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

load-gvm() {
  if [ -f "go.mod" ]; then
    local version=(`awk '/^go / {print $1$2}' go.mod`)
    gvm use ${version}
  fi
}
add-zsh-hook chpwd load-gvm
load-gvm

# https://asdf-vm.com/guide/getting-started.html#_3-install-asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# https://docs.docker.com/engine/reference/commandline/system_prune/
docker-nuke() {
  docker kill $(docker ps -q)
  docker rmi -f $(docker images -a -q)
  docker system prune -a --volumes -f
}

# https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/
alias k="kubectl"
source <(kubectl completion zsh)
autoload -Uz compinit
complete -F __start_kubectl k

# https://github.com/wercker/stern
source <(stern --completion=zsh)

# nvm bash completion.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# https://github.com/nvm-sh/nvm#calling-nvm-use-automatically-in-a-directory-with-a-nvmrc-file
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# https://direnv.net/
eval "$(direnv hook zsh)"

# https://sdkman.io/install
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Misc tools and local binaries.
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="$PATH:~/.local/bin"
