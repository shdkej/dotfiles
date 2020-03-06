#!/bin/bash
# install package
cd ~
sudo apt-get install -y curl vim zsh tmux 
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs

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

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# zsh highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# zsh auto suggestions
echo "###INSTALL auto suggestions###"
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh docker
echo "###INSTALL zsh docker###"
mkdir -p ~/.oh-my-zsh/plugins/docker/
curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
rm ~/.zshrc
echo "###link zshrc###"
ln environment/.zshrc ~/.zshrc
sudo chsh -s /usr/bin/zsh

# check install extension
echo "## Do install extensions? ##"
read check_update
if [ $check_update = "n" ]
then
    break
fi

# docker
echo "test"

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
source ~/.zshrc
