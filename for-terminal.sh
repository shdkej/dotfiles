#!/bin/bash

set -u -e

OS="$(uname -s)"
DOTFILES=~/workspace/dotfiles
RESULT=""

# ============================================================
# 1. 패키지 설치
# ============================================================
case "$OS" in
    Linux*)
        SUDO=''
        if [ "$(whoami)" != "root" ]; then
            SUDO='sudo'
        fi
        BASIC_PACKAGES='python3 python3-pip curl vim zsh tmux wget xclip'
        DEVELOP_PACKAGES='silversearcher-ag ripgrep bat fzf jq'
        if ! dpkg -s $BASIC_PACKAGES >/dev/null 2>&1; then
            echo "###\nPackage Install\n###"
            $SUDO apt update -y
            $SUDO apt-get install -y $BASIC_PACKAGES $DEVELOP_PACKAGES
        fi
        ;;
    Darwin*)
        echo "macOS brew 설정은 for-mac.sh를 사용하세요"
        ;;
esac


# ============================================================
# 2. Vim
# ============================================================
VIMRC=~/.vimrc
echo "###\nSetting VIM\n###"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ -e $VIMRC  ]
then
    mv $VIMRC $VIMRC.backup || rm $VIMRC
fi
ln -s $DOTFILES/.vimrc $VIMRC || RESULT="${RESULT}\n Fail vim link dotfile"
ln -s $DOTFILES/vimconfig ~/.vim/ || RESULT="${RESULT}\n Fail Vim Link Vim Config"
#source $VIMRC || RESULT="${RESULT}\n Fail vim execute source"
#vim +'PlugInstall' +qall > /dev/null || RESULT="${RESULT}\n Fail vim plugin install"


# ============================================================
# 3. Oh My Zsh
# ============================================================
ZSH_CONFIG=~/.zshrc
if [ -e $ZSH_CONFIG  ]
then
    mv $ZSH_CONFIG $ZSH_CONFIG.backup || rm $ZSH_CONFIG
fi
echo "###INSTALL OH MY ZSH###"
yes | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# zsh highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# zsh auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh z
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
ln -s $DOTFILES/.zshrc $ZSH_CONFIG || RESULT="${RESULT}\n Fail zsh link dotfile"


# ============================================================
# 4. Tmux
# ============================================================
if [ -z ${1+x} ] # has any argument with run script then skip
then
    TMUX_CONFIG=~/.tmux.conf
    echo -e "###\nSetting tmux\n###"
    if [ -e $TMUX_CONFIG ]
    then
        mv $TMUX_CONFIG $TMUX_CONFIG.backup || rm $TMUX_CONFIG
    fi
    ln $DOTFILES/.tmux.conf $TMUX_CONFIG || RESULT="${RESULT}\n Fail tmux link dotfile"
    mkdir -p ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || RESULT="${RESULT}\n Fail tmux plugin manager install"
    #tmux source $TMUX_CONFIG
fi


# ============================================================
# 5. FZF
# ============================================================
echo "###\nInstall fzf\n###"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# ============================================================
# 6. asdf 런타임 설치
# ============================================================
if command -v asdf &>/dev/null; then
    echo "###\nSetting asdf runtimes\n###"

    # 플러그인 추가 (이미 있으면 무시)
    asdf plugin add nodejs 2>/dev/null || true
    asdf plugin add java 2>/dev/null || true
    asdf plugin add yarn 2>/dev/null || true

    # nodejs
    asdf install nodejs 24.3.0 || true
    asdf install nodejs 22.21.1 || true
    asdf install nodejs 20.15.1 || true
    asdf install nodejs 18.20.8 || true

    # java
    asdf install java zulu-8.52.0.23 || true
    asdf install java openjdk-17.0.2 || true

    # yarn
    asdf install yarn 1.22.11 || true

    # 기본 버전 설정
    asdf global nodejs 24.3.0
    asdf global java zulu-8.52.0.23
    asdf global yarn 1.22.11
else
    echo "asdf가 설치되어 있지 않습니다. brew install asdf 후 다시 실행하세요."
fi


# ============================================================
# 7. Snippet + 결과
# ============================================================
echo "${RESULT}"
echo "###\n----Copy below Code\n###"
echo "source ~/.vimrc && source ~/.zshrc"
echo "tmux source ~/.tmux.conf"
echo "chsh -s /usr/bin/zsh"
echo "git config --global user.email 'shdkej@github.com'"
echo "git config --global user.name 'shdkej'"
echo "git config --global core.editor 'vim'"
ln -s $DOTFILES/UltiSnips/ ~/.vim/UltiSnips
