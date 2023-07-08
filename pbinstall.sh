#!/bin/sh
apk add certbot curl zip  \ 
wget -b -O pb.zip "$(curl -s "https://api.github.com/repos/pocketbase/pocketbase/releases/assets/115395053" |  grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')"   \
unzip -o -qq  pb.zip -d pb   \ 
mkdir -p /var/app  && 
cp -R /root/pb /var/app   \ 

while getopts d:e: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
        e) email=${OPTARG};;
    esac
done

certbot certonly --standalone -n -d $domain --staple-ocsp -m $email --agree-tos   \ 
/root/pb/pocketbase serve --http=$domain:80 --https=$domain:443  \
certbot renew --dry-run // check \
certbot renew \
crontab -e \
echo "45       2       *       *       6       certbot renew" | crontab -e" \