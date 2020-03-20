#!/bin/bash
set -u -e

SUDO=''
if [ "$(whoami)" != "root" ]
then
    echo "$(whoami)"
    SUDO='sudo'
    # key mapping
    #setxkbmap -option keypad:pointerkeys # set number key
    #setxkbmap -option caps:escape # Caps lock as esc
fi


# install package
cd ~
echo -e "###\nPackage Install\n###"
#sudo apt-add-repository ppa:fish-shell/release-3
$SUDO apt-get install -y curl vim fish tmux 
curl -sL https://deb.nodesource.com/setup_13.x | $SUDO bash -
$SUDO apt-get install -y nodejs python3 python3-pip


# install programming package
echo -e "###\nProgramming Package Install\n###"
$SUDO apt-get install -y ctags flake8 silversearcher-ag


# vim plug
VIMRC="~/.vimrc"
echo -e "###\nSetting VIM\n###"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ -e $VIMRC  ]
then
    mv $VIMRC $VIMRC.backup
fi
ln ~/environment/.vimrc $VIMRC
source $VIMRC || echo "Fail execute source"
vim -c 'PlugInstall' -c 'qa!'
pip3 install python-language-server


# fish
FISH_CONFIG="~/.config/fish/config.fish"
echo -e "###\nSetting fish shell\n###"
if [ -e $FISH_CONFIG  ]
then
    mv $FISH_CONFIG $FISH_CONFIG.backup
fi
ln ~/environment/config.fish $FISH_CONFIG
source $FISH_CONFIG
$SUDO chsh -s /usr/bin/fish


# tmux
# ---
TMUX_CONFIG="~/.tmux.conf"
echo -e "###\nSetting fish shell\n###"
if [ -e $TMUX_CONFIG ]
then
    mv $TMUX_CONFIG $TMUX_CONFIG.backup
fi
ln ~/environment/.tmux.conf $TMUX_CONFIG
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source $TMUX_CONFIG


# fzf
echo -e "###\nInstall fzf\n###"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install


# snippet
echo -e "###\nSetting Snippet\n###"
ln -s ~/environment/UltiSnips ~/.vim/

# joplin
# wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
# NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin
# sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin
# joplin desktop app terminal app sync
#mv \
#~/.config/joplin \
#~/.config/joplin-terminal-bak && \
# ln -sfn \
# ~/.config/joplin-desktop/ \
# ~/.config/joplin

