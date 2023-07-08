#!/bin/bash
while getopts d:e: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
        e) email=${OPTARG};;
    esac
done

apk update && apk add curl wget unzip jq certbot &&
wget -b $(curl -sL https://api.github.com/repos/pocketbase/pocketbase/releases/latest | jq -r ".assets[].browser_download_url" | grep _linux_amd64.zip) -O '/tmp/pocketbase.zip' &&
unzip /tmp/pocketbase.zip -d /usr/local/bin/  &&
rm /tmp/pocketbase.zip  &&
mkdir /pb_data  &&
chown /usr/local/bin/pocketbase  &&
chown /pb_data  &&
chmod 710 /usr/local/bin/pocketbase  &&
certbot certonly --standalone -n -d ${domain} --staple-ocsp -m ${email} --agree-tos
/usr/local/bin/pocketbase serve --http="${domain}:80" --https="${domain}:443" 
