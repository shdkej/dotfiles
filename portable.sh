#!/bin/bash
# install package
cd ~
apt-get install -y curl vim fish

# vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
rm ~/.vimrc
ln environment/.vimrc ~/.vimrc
vim -c 'PlugInstall' -c 'qa!'

chsh -s /usr/bin/fish

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
