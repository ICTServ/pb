#!/bin/sh
apk update  && apk add certbot curl wget zip
wget -b -O pb.zip "$(curl -s "https://api.github.com/repos/pocketbase/pocketbase/releases/assets/115395053" |  grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')" &&
unzip -o -qq  pb.zip -d pb
mkdir -p /var/app
cp -R /root/pb /var/app

while getopts ":d:e:" opt; do
      case $opt in
        d ) DOMAIN="$OPTARG";;
        e ) EMAIL="$OPTARG";;
        \?) echo "Invalid option: -"$OPTARG"" >&2
            exit 1;;
        : ) echo "Option -"$OPTARG" requires an argument." >&2
            exit 1;;
      esac
done

certbot certonly --standalone -n -d $DOMAIN --staple-ocsp -m $EMAIL --agree-tos 
/root/pb/pocketbase serve --http=$DOMAIN:80 --https=$DOMAIN:443

certbot renew -n
echo "45       2       *       *       6       certbot renew" | crontab -e" 
