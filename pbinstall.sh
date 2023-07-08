#!/bin/bash
# apk update && apk add certbot && apk add curl && apk add zip  \ 
mkdir -p /var/app/pb &&
wget -O /tmp/pb.zip "$(curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/assets/115395053 |  grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')"  &&
cd /tmp  &&
unzip -o -qq pb.zip &&
cp pocketbase /var/app/pb &&
cd  &&
while getopts d:e: opt; do
    case "$opt" in
        d) domain=$OPTARG;;
        e) email=$OPTARG;;
    esac
done
certbot certonly --standalone -n -d $domain --staple-ocsp -m $email --agree-tos  && 
/root/pb/pocketbase serve --http=$domain:80 --https=$domain:443  &&

# certbot certonly --standalone -n -d example.com --staple-ocsp -m email@example.com --agree-tos  && 
# /var/app/pb/pocketbase serve --http=example.com:80 --https=example.com:443  &&
certbot renew &&
crontab -e &&
echo `45       2       *       *       6       certbot renew | crontab -e` 

# wget http://raw.githubusercontent.com/ICTServ/pb/main/pbinstall.sh -O pbinstall.sh  && sh pbinstall.sh -d “example.com” -e “email@example.com”
