#!/bin/bash


FILE=$1
readarray -t LINES < "$FILE"

for list in "${LINES[@]}";

do
#download file zone cloudfare
cf-backup administrator@domain.com 2abfa4g3d393cbfd13az518xe06f42fb2e96f -z $list -o /usr/local/script/backup_zones/domain_zones_cloudflare >> /var/log/output.log 2>&1
done

### FTP ###
FTPD="/"
FTPU="dns"
FTPP="90132v7Lb1UN"
FTPS="server.domain.com"

#pass to archive
ARCHIVE_pass="BzKU6dMBAadN3zws2j"

### Binaries ###
TAR="/usr/bin/tar"
FTP="/usr/local/bin/lftp"

## Today + hour in 24h format ###
NOW=$(date +%Y%m%d)

### Create tmp dir ###
mkdir /usr/local/script/backup_zones/$NOW

## go folder ##
cd /usr/local/script/backup_zones/

## create archive ##
$TAR -zcf - domain_zones_cloudflare/ | openssl aes-128-cbc -k $ARCHIVE_pass -salt -out /usr/local/script/backup_zones/$NOW/domain_zones.tar.gz.aes

### send archive to ftp server ###

cd /usr/local/script/backup_zones/
$FTP -u $FTPU,$FTPP -e "mkdir $FTPD/$NOW; cd $FTPD/$NOW; mput $NOW/*; quit" $FTPS

## clear folder NOW ##

cd /usr/local/script/backup_zones/
rm -r $NOW

## clear folder backup ##
cd /usr/local/script/backup_zones/
rm -r domain_zones_cloudflare

