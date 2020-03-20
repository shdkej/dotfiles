# vim
if [[ -e ~/.vimrc.backup ]] then
    echo -e "###\nVIM Cleaning\n###"
    mv ~/.vimrc.backup ~/.vimrc
    vim -c 'PlugClean' -c 'qa!'
fi


# tmux
if [[ -e ~/.tmux.conf.backup ]] then
    echo -e "###\nTMUX Cleaning\n###"
    mv ~/.tmux.conf.backup ~/.tmux.conf
    rm -rf ~/.tmux/plugins
    tmux source ~/.tmux.conf
fi


# fish
if [[ -e ~/.config/fish/.config.fish.backup ]] then
    echo -e "###\nFISH Cleaning\n###"
    mv ~/.config/fish/.config.fish.backup ~/.config/fish/.config.fish
fi
