#!/bin/bash

rclone sync /home/sh/vimwiki onedrive:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf --exclude ".git/**"

rclone sync /home/sh/workspace onedrive:/workspace -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf --exclude "**/bin/**" \
    --exclude ".git/**" --exclude "golang/pkg/**" --exclude "**/.terraform/**"
