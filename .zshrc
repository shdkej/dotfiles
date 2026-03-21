# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="juanghurtado"

KEYTIMEOUT=1

# Node.js가 macOS 시스템 CA 인증서를 사용하도록 설정
export NODE_OPTIONS="--use-system-ca"

# Plugins
plugins=(
  git
  docker
  docker-compose
  fasd
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR=vim
export LANG=ko_KR.UTF-8

# FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS="--extended"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Custom aliases
alias vi=nvim
alias cc=claude
alias cat='bat --theme "Monokai Extended"'
alias pip=pip3
alias k=kubectl
alias v='aws-vault exec kop --'
alias h='cd ~/dev/kolon_kop/hybris/bin/platform'
alias c='agy .'
alias duh='du -h | sort -h | tail'
alias gs='git status'
alias addcert='yarn config set cafile /Users/seongho-noh/.ca/KOLON.crt --global; npm config set cafile /Users/seongho-noh/.ca/KOLON.crt --global'
alias delcert='yarn config delete cafile --global ; npm config -g delete cafile ; npm config delete cafile ; yarn config delete cafile'

# fzf functions

# cd extend
function cdf() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

# fzf file edit
fe() (
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
)

# docker start & exec
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && docker start "$cid" && docker exec -it "$cid" sh
}

# docker logs
function dl() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
    [ -n "$cid" ] && docker start "$cid" && docker logs -f --tail 10 "$cid"
}

# go to git directory
function zz() {
    dir=$(find $HOME/workspace -name ".git" | fzf)
    cd $dir/..
}

# PATH
export PATH="/Users/seongho-noh/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export KUBECONFIG=~/.kube/config:~/.kube/my-oracle-k3s-kubeconfig.yaml

# Secrets (별도 파일로 분리)
[[ -f ~/.env.local ]] && source ~/.env.local

# autocompletion
autoload -U +X bashcompinit && bashcompinit

# 전체 패키지 업데이트
alias update-all='echo "=== Brew ===" ; brew update && brew upgrade && brew upgrade --cask && brew cleanup ; echo "=== npm ===" ; npm update -g ; echo "=== Oh My Zsh ===" ; omz update ; echo "=== Neovim ===" ; nvim --headless "+Lazy! sync" +qa ; echo "=== Ruby Gems ===" ; gem update ; echo "=== asdf ===" ; asdf plugin update --all ; echo "=== Claude ===" ; claude update ; echo "=== Done ==="'

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
