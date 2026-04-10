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
# 6. Snippet + 결과
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
