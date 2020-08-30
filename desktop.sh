#/bin/bash

# theme

# font
#wget https://github.com/naver/d2codingfont/releases/download/VER1.21/D2Coding-1.2.zip ~/
#unzip ~/D2Coding-1.2.zip -d ~/
#sudo gnome-font-viewer D2Coding.ttf

# touchpad gesture
sudo gpasswd -a $USER input
sudo apt-get install xdotool wmctrl
sudo apt-get install libinput-tools
git clone https://github.com/bulletmark/libinput-gestures.git ~/
cd ~/libinput-gestures
sudo make install
libinput-gestures-setup autostart
libinput-gestures-setup start
ln ~/dotfiles/libinput-gestures.conf ~/.config/

# rclone
sudo apt-get install -y rclone
rclone copy onedrive:workpsace ~/workspace
rclone copy onedrive:vimwiki ~/wiki-blog/content
#echo "0 */1   * * *   root    /home/sh/dotfiles/rclone.sh >/dev/null 2>&1" >> /etc/crontab

sudo crontab /home/sh/dotfiles/crontab

##
echo "## Change terminal font"
echo "## install Chrome"
echo "## tmux source"
