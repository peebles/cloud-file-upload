#!/bin/bash

( cd server; npm install )
htpasswd -cb /etc/nginx/.htpasswd $SITE_USER $SITE_PASSWORD
if [ ! -d "server/public/tmp" ]; then
    mkdir -p server/public/tmp
fi
if [ ! -d "server/public/files" ]; then
    mkdir -p server/public/files
fi
sed -i "s/__TITLE__/$SITE_TITLE/g" index.html
sed -i "s/__DESCRIPTION__/$SITE_DESCRIPTION/g" index.html
( cd server; node server.js & )
nginx -g 'daemon off;'
