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
SCREENSHOTDIR=~/vimwiki/screenshot

if [ $1 = 'pomodoro' ] && [ $2 = 'complete' ]
then
    gnome-screenshot -f $SCREENSHOTDIR/$SCREENSHOT
    # image link to file
    echo ![$DATETIME]'('../screenshot/$SCREENSHOT')' >> $DIR/$FILE
    echo [[local:$SCREENSHOTDIR/$SCREENSHOT]] >> $DIR/$FILE
fi

echo 'script done'

find $SCREENSHOTDIR -name "*.png" -type f -mtime +3 -delete
echo 'delete old file'
