#!/bin/bash

set -u -e

SUDO=''
x=''
if [ "$(whoami)" != "root" ]
then
    SUDO='sudo'
fi

DOTFILES=~
if [ -z ${1+x} ] # has any argument with run script then skip
then
    DOTFILES='~/dotfiles'
fi
# install package
echo "###\nPackage Install\n###"
#sudo apt-add-repository ppa:fish-shell/release-3
$SUDO apt-get install -y nodejs python3 python3-pip
$SUDO apt-get install -y curl vim zsh tmux xcape
if [ -z ${1+x} ] # has any argument with run script then skip
then
    curl -sL https://deb.nodesource.com/setup_12.x | $SUDO bash -
    wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
    $SUDO tar -xvf go1.14.3.linux-amd64.tar.gz
    $SUDO mv go /usr/local
    $SUDO apt update -y
    $SUDO apt install -y golang-go
fi


# install programming package
echo "###\nProgramming Package Install\n###"
$SUDO apt-get install -y ctags flake8 silversearcher-ag

# vim plug
VIMRC=~/.vimrc
echo "###\nSetting VIM\n###"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ -e $VIMRC  ]
then
    mv $VIMRC $VIMRC.backup || rm $VIMRC
fi
ln $DOTFILES/.vimrc $VIMRC
source $VIMRC || echo "Fail execute source"
#vim +'PlugInstall' +qall > /dev/null
pip3 install python-language-server

# oh-my-zsh
ZSH_CONFIG=~/.zshrc
if [ -e $ZSH_CONFIG  ]
then
    mv $ZSH_CONFIG $ZSH_CONFIG.backup || rm $ZSH_CONFIG
fi
ln $DOTFILES/.zshrc $ZSH_CONFIG
echo "###INSTALL OH MY ZSH###"
yes | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# zsh highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# zsh auto suggestions
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

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
    ln $DOTFILES/.tmux.conf $TMUX_CONFIG
    mkdir -p ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || echo ""
    #tmux source $TMUX_CONFIG
fi


# fzf
echo "###\nInstall fzf\n###"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install


# snippet
echo "###\nSetting Snippet\n###"
ln -s $DOTFILES/UltiSnips/ ~/.vim/UltiSnips

echo "###\nCopy below Code\n###"
echo "###\nsource ~/.vimrc && source ~/.zshrc\n###"
echo "tmux source ~/.tmux.conf"
echo "chsh -s /usr/bin/zsh"
