# vim
if [[ -e ~/.vimrc.backup ]]
then
    echo "###\nVIM Cleaning\n###"
    mv ~/.vimrc.backup ~/.vimrc
    vim -c 'PlugClean' -c 'qa!'
fi


# tmux
if [[ -e ~/.tmux.conf.backup ]]
then
    echo "###\nTMUX Cleaning\n###"
    mv ~/.tmux.conf.backup ~/.tmux.conf
    rm -rf ~/.tmux/plugins
    tmux source ~/.tmux.conf
fi


# zsh
if [[ -e ~/.zshrc.backup ]]
then
    echo "###\nZSH Cleaning\n###"
    mv ~/.zshrc.backup ~/.zshrc
fi
