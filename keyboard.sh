#!/bin/bash
setxkbmap -option keypad:pointerkeys
setxkbmap -option 'caps:ctrl_modifier' \
    && xcape -e 'Caps_Lock=Escape'
xset r rate 350 60
xkbset ma 60 10 10 5 10
