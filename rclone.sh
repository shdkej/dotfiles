#!/bin/bash

rclone sync /home/sh/wiki-blog/content onedrive:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "node_modules/**"
    #--exclude ".git/**"

rclone sync /home/sh/workspace onedrive:/workspace -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "**/bin/**" \
    --exclude "**/.terraform/**" \
    --exclude "node_modules/**" \
    --exclude "*.h5" \
    --filter "+ golang/src/github.com/shdkej/**" \
    --filter "+ golang/test/**" \
    --filter "- golang/**" \
    --max-size 50M
    #--exclude ".git/**"

rclone sync /home/sh/wiki-blog/content google:/vimwiki -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "node_modules/**"
    #--exclude ".git/**"

rclone sync /home/sh/workspace google:/workspace -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --exclude "**/bin/**" \
    --exclude "**/.terraform/**" \
    --exclude "node_modules/**" \
    --exclude "*.h5" \
    --filter "+ golang/src/github.com/shdkej/**" \
    --filter "+ golang/test/**" \
    --filter "- golang/**" \
    --max-size 50M
    #--exclude ".git/**"

rclone sync onedrive:/document google:/document -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --max-size 50M

rclone sync onedrive:/document /home/sh/document -v --log-file /tmp/rclone.log \
    --config /home/sh/.config/rclone/rclone.conf \
    --max-size 50M
