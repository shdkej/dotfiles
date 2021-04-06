#!/bin/bash

rclone sync /home/sh/wiki-blog/content onedrive:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "node_modules/**"
    #--exclude ".git/**"

rclone sync /home/sh/workspace onedrive:/workspace -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "**/bin/**" \
    --exclude "golang/pkg/**" \
    --exclude "**/.terraform/**" \
    --exclude "node_modules/**" \
    --exclude "*.h5"
    #--exclude ".git/**"

rclone sync /home/sh/wiki-blog/content google:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    #--exclude ".git/**"
    --exclude "node_modules/**"

rclone sync /home/sh/workspace google:/workspace -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "**/bin/**" \
    --exclude "golang/pkg/**" \
    --exclude "**/.terraform/**" \
    --exclude "node_modules/**" \
    --exclude "*.h5"
    #--exclude ".git/**"
