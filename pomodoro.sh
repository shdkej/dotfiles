#/bin/bash

# File name has include week
DIR=~/vimwiki/diary
FILE=$(date '+%Y-%m-%d').md

TEXT='#### '$(date '+%F %H:%M')' POMODORO/'$*

# write today file
echo $TEXT >> $DIR/$FILE

# capture screen
DATETIME=$(date '+%F_%H-%M')
SCREENSHOT=$DATETIME.png

if [ $1 = 'pomodoro' ] && [ $2 = 'complete' ]
then
    gnome-screenshot -f $DIR/$SCREENSHOT
    # image link to file
    echo ![$DATETIME]'('$SCREENSHOT')' >> $DIR/$FILE
    echo [[local:$DIR/$SCREENSHOT]] >> $DIR/$FILE
fi

echo 'script done'
