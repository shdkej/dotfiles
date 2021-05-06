#/bin/bash

# theme
sudo add-apt-repository universe
sudo apt install -y gnome-tweak-tool
sudo apt-get install -y gnome-shell-pomodoro

# font
#wget https://github.com/naver/d2codingfont/releases/download/VER1.21/D2Coding-1.2.zip ~/
#unzip ~/D2Coding-1.2.zip -d ~/
#sudo gnome-font-viewer D2Coding.ttf

# touchpad gesture
sudo gpasswd -a $USER input
sudo apt-get -y install xdotool wmctrl
sudo apt-get -y install libinput-tools
git clone https://github.com/bulletmark/libinput-gestures.git ~/libinput-gestures
cd ~/libinput-gestures
sudo make install
libinput-gestures-setup autostart
libinput-gestures-setup start
ln ~/dotfiles/libinput-gestures.conf ~/.config/

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb


# rclone
sudo apt-get install -y rclone
echo "## Copy workspace to local"
rclone copy onedrive:workspace ~/workspace

git clone https://github.com/shdkej/shdkej.github.io ~/wiki-blog
rm -rf ~/wiki-blog/content
echo "## Copy vimwiki to local"
rclone copy onedrive:vimwiki ~/wiki-blog/content

# cron job
sudo crontab /home/sh/dotfiles/crontab

# npm global directory
mkdir ~/.npm-global
npm config set prefix '~/npm-global'

# git command line tool
npm install -g git-cz
npm install -g actions-cli

# done
echo "## Change terminal font"
echo "## install Chrome"
echo "## tmux source"
