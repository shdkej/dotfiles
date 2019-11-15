#!/bin/bash
cd ~
sudo apt-get install -y vim zsh tmux

#vim vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
rm ~/.vimrc
ln environment/.vimrc ~/.vimrc
vim -c 'PluginInstall' -c 'qa!'

#oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#zsh highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#zsh auto suggestions
echo "###INSTALL auto suggestions###"
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#zsh docker
echo "###INSTALL zsh docker###"
mkdir -p ~/.oh-my-zsh/plugins/docker/
curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
rm ~/.zshrc
echo "###link zshrc###"
ln environment/.zshrc ~/.zshrc
sudo chsh -s /usr/bin/zsh
