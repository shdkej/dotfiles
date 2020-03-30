#!/bin/bash

rclone sync /home/sh/vimwiki onedrive:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf
