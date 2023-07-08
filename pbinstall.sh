#!/bin/bash
# apk update && apk add certbot && apk add curl && apk add zip  \ 
mkdir -p /var/app
curl `$(curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/assets/115395053 |  grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')` -o /tmp/pb.zip  \
unzip -o -qq /tmp/pb.zip -d /var/app   \ 
while getopts d:e: opt; do
    case "$opt" in
        d) domain=$OPTARG;;
        e) email=$OPTARG;;
    esac
done
certbot certonly --standalone -n -d $domain --staple-ocsp -m $email --agree-tos   \ 
/root/pb/pocketbase serve --http=$domain:80 --https=$domain:443  \
certbot renew \
crontab -e \
echo `45       2       *       *       6       certbot renew | crontab -e` \
