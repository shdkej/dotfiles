#!/bin/bash
set -u -e

SUDO=''
if [ "$(whoami)" != "root" ]
then
    SUDO='sudo'
fi


# install package
echo -e "###\nPackage Install\n###"
#sudo apt-add-repository ppa:fish-shell/release-3
$SUDO apt-get install -y curl vim fish tmux xcape
curl -sL https://deb.nodesource.com/setup_13.x | $SUDO bash -
$SUDO apt-get install -y nodejs python3 python3-pip
$SUDO add-apt-repository ppa:longsleep/golang-backports
$SUDO apt update
$SUDO apt install -y golang-go


# install programming package
echo -e "###\nProgramming Package Install\n###"
$SUDO apt-get install -y ctags flake8 silversearcher-ag

# key mapping
setxkbmap -option keypad:pointerkeys || echo "set key" # set number key
setxkbmap -option 'caps:ctrl_modifier' \
    && xcape -e 'Caps_Lock=Escape' || echo "set key" # Caps lock as esc, when pressed as Ctrl

# vim plug
VIMRC=~/.vimrc
echo -e "###\nSetting VIM\n###"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ -e $VIMRC  ]
then
    mv $VIMRC $VIMRC.backup
fi
ln .vimrc $VIMRC
source $VIMRC || echo "Fail execute source"
#vim +'PlugInstall' +qall > /dev/null
pip3 install python-language-server


# fish
FISH_CONFIG=~/.config/fish/config.fish
echo -e "###\nSetting fish shell\n###"
if [ -e $FISH_CONFIG  ]
then
    mv $FISH_CONFIG $FISH_CONFIG.backup
fi
mkdir -p ~/.config/fish
ln config.fish $FISH_CONFIG
source $FISH_CONFIG || echo "Fail execute source"
$SUDO chsh -s /usr/bin/fish


# tmux
# ---
x=''
if [ -z ${1+x} ] # has any argument with run script then skip
then
    TMUX_CONFIG=~/.tmux.conf
    echo -e "###\nSetting fish shell\n###"
    if [ -e $TMUX_CONFIG ]
    then
        mv $TMUX_CONFIG $TMUX_CONFIG.backup
    fi
    ln .tmux.conf $TMUX_CONFIG
    mkdir -p ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux source $TMUX_CONFIG
fi


# fzf
echo -e "###\nInstall fzf\n###"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install


# snippet
echo -e "###\nSetting Snippet\n###"
ln -s UltiSnips/ ~/.vim/UltiSnips

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

