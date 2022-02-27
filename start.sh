#!/bin/bash

read -p "   Inputkan nama ISO Disk-1           : "iso1;
read -p "   Inputkan nama ISO Disk-2           : "iso2;
read -p "   Inputkan nama ISO Disk-3           : "iso3;
read -p "   Inputkan nama anda                 : "nama;
read -p "   Inputkan alamat Address anda       : "ip;

apt update 
apt install apache2 dpkg-dev rsync
mkdir /repo
mkdir /media/dvd1
mkdir /media/dvd2
mkdir /media/dvd3
mkdir -p /repo/pool/
mkdir -p /repo/dists/$nama/main/binary-amd64/
mkdir -p /repo/dists/$nama/main/source/
mount -o loop dvd/$iso1 /media/dvd1
mount -o loop dvd/$iso2 /media/dvd2
mount -o loop dvd/$iso3 /media/dvd3
rsync -avH /media/dvd1/pool /repo/pool
rsync -avH /media/dvd2/pool /repo/pool
rsync -avH /media/dvd3/pool /repo/pool
cd /repo/
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
dpkg-scansources . /dev/null | gzip -9c > Sources.gz
mv Packages.gz /repo/dists/$nama/main/binary-amd64/
mv Sources.gz /repo/dists/$nama/main/source/
ln -s /repo /var/www/html/
echo "deb [trusted=yes] http://$ip/repo $nama main"
apt update