#!/bin/bash
# install package
cd ~
#sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get install -y curl vim fish tmux 
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs python3 python3-pip

# install programming package
sudo apt-get install -y ctags flake8 silversearcher-ag

# key mapping
setxkbmap -option keypad:pointerkeys # set number key
setxkbmap -option caps:escape # Caps lock as esc

# vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
rm ~/.vimrc
ln environment/.vimrc ~/.vimrc
vim -c 'PlugInstall' -c 'qa!'

pip3 install python-language-server

# fish
ln environment/config.fish ~/.config/fish/config.fish
sudo chsh -s /usr/bin/fish

# tmux
ln environment/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf

# joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin
sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin
# joplin desktop app terminal app sync
#mv \
#~/.config/joplin \
#~/.config/joplin-terminal-bak && \
ln -sfn \
~/.config/joplin-desktop/ \
~/.config/joplin

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# snippet
ln -s ~/UltiSnips ~/.vim/