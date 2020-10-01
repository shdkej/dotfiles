#!/bin/bash

rclone sync /home/sh/wiki-blog/content onedrive:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf
    #--exclude ".git/**"

rclone sync /home/sh/workspace onedrive:/workspace -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "**/bin/**" \
    --exclude "golang/pkg/**" \
    --exclude "**/.terraform/**" \
    --exclude "node_modules/**"
    #--exclude ".git/**"
