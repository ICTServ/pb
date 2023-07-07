#!/bin/sh
apk update  && apk add certbot curl wget zip
wget -b -O pb.zip "$(curl -s "https://api.github.com/repos/pocketbase/pocketbase/releases/assets/115395053" |  grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')" &&
unzip -o -qq  pb.zip -d pb
mkdir -p /var/app
cp -R /root/pb /var/app

echo "Domain: $D"
echo "Email: $E"

certbot certonly --standalone -n -d $D --staple-ocsp -m $E --agree-tos 
/root/pb/pocketbase serve --http=$domain:80 --https=$domain:443

certbot renew -n
echo "45       2       *       *       6       certbot renew" | crontab -e" 
