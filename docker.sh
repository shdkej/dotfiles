#!/bin/bash

apt install -y docker.io
curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
usermod -aG docker $USER
chmod 755 /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
