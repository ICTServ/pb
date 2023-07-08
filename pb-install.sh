#!/bin/sh
apk update  && apk add certbot curl wget zip
wget -b -O pb.zip "$(curl -s "https://api.github.com/repos/pocketbase/pocketbase/releases/assets/115395053" |  grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')" &&
unzip -o -qq  pb.zip -d pb  &&
mkdir -p /var/app  &&
cp -R /root/pb /var/app  &&

while getopts d:e: flag
do
    case "${flag}" in
        d) dmn=${OPTARG};;
        e) eml=${OPTARG};;
    esac
done

certbot certonly --standalone -n --domain $dmn --staple-ocsp -m $eml --agree-tos &&
cd /root/pb/ &&
./pocketbase serve --http=$dmn:80 --https=$dmn:443
