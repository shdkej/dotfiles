#!/bin/bash

set -u -e

SUDO=''
x=''
if [ "$(whoami)" != "root" ]
then
    SUDO='sudo'
fi

DOTFILES=~/dotfiles
if [ "${1+x}" == "github" ] # has any argument with run script then skip
then
    DOTFILES=~/work/dotfiles/dotfiles
fi

# install package
BASIC_PACKAGES='python3 python3-pip curl vim zsh tmux xcape wget xclip'
DEVELOP_PACKAGES='ctags flake8 silversearcher-ag'
if ! dpkg -s $BASIC_PACKAGES >/dev/null 2>&1; then
    echo "###\nPackage Install\n###"
    $SUDO apt update -y
    $SUDO apt-get install -y $BASIC_PACKAGES

    # install programming package
    echo "###\nProgramming Package Install\n###"
    $SUDO apt-get install -y $DEVELOP_PACKAGES
fi

if [ -z ${1+x} ] # has any argument with run script then skip
then
    if ! dpkg -s golang-go >/dev/null 2>&1; then
        curl -sL https://deb.nodesource.com/setup_12.x | $SUDO bash -
        wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
        $SUDO tar -xvf go1.14.3.linux-amd64.tar.gz
        $SUDO mv go /usr/local
        $SUDO rm go1.14.3.linux-amd64.tar.gz
        $SUDO apt update -y
        $SUDO apt install -y golang-go nodejs
    fi
fi


RESULT=""

# vim plug
VIMRC=~/.vimrc
echo "###\nSetting VIM\n###"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ -e $VIMRC  ]
then
    mv $VIMRC $VIMRC.backup || rm $VIMRC
fi
ln $DOTFILES/.vimrc $VIMRC || RESULT="${RESULT}\n Fail vim link dotfile"
#source $VIMRC || RESULT="${RESULT}\n Fail vim execute source"
#vim +'PlugInstall' +qall > /dev/null || RESULT="${RESULT}\n Fail vim plugin install"
#pip3 install python-language-server

# oh-my-zsh
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
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm $ZSH_CONFIG
ln $DOTFILES/.zshrc $ZSH_CONFIG || RESULT="${RESULT}\n Fail zsh link dotfile"

# tmux
# ---
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


# fzf
echo "###\nInstall fzf\n###"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install


# snippet
echo "###\nSetting Snippet\n###"

echo "${RESULT}"
echo "###\n----Copy below Code\n###"
echo "source ~/.vimrc && source ~/.zshrc"
echo "tmux source ~/.tmux.conf"
echo "chsh -s /usr/bin/zsh"
echo "git config --global user.email 'shdkej@github.com'"
echo "git config --global user.name 'shdkej'"
echo "git config --global core.editor 'vim'"
ln -s $DOTFILES/UltiSnips/ ~/.vim/UltiSnips
