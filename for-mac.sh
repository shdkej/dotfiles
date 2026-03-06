DOTFILES=~/workspace/dotfiles

# brew 설치 및 Brewfile 적용
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew bundle --file="$DOTFILES/Brewfile" || echo "Fail brew bundle"

# hammerspoon key binding
CONFIG=~/.hammerspoon/init.lua
echo "###\nSetting Hammerspoon\n###"

if [ -e $CONFIG  ]
then
    mv $CONFIG $CONFIG.backup || rm $CONFIG
fi
ln -s $DOTFILES/hammerspoon-init.lua ~/.hammerspoon/init.lua || RESULT="${RESULT}\n Fail Link Hammerspoon Config"

# karabiner key binding
KARABINER_CONFIG=~/.config/karabiner/karabiner.json
echo "###\nSetting Karabiner\n###"

mkdir -p ~/.config/karabiner
if [ -e $KARABINER_CONFIG ]
then
    mv $KARABINER_CONFIG $KARABINER_CONFIG.backup || rm $KARABINER_CONFIG
fi
ln -s $DOTFILES/karabiner-settings.json $KARABINER_CONFIG || RESULT="${RESULT}\n Fail Link Karabiner Config"