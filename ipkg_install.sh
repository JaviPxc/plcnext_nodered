#!/bin/sh
feed=http://ipkg.nslu2-linux.org/optware-ng/buildroot-armeabihf
ipk_name=$(wget -qO- $feed/Packages | awk '/^Filename: ipkg-static/ {print $2}')
wget -O /tmp/$ipk_name $feed/$ipk_name
tar -C /tmp -xvzf /tmp/$ipk_name ./data.tar.gz
tar -C / -xzvf /tmp/data.tar.gz --transform 's/opt/opt\/ipkg/'
rm -f /tmp/$ipk_name /tmp/data.tar.gz
echo "src/gz optware-ng $feed" > /opt/ipkg/etc/ipkg.conf
echo "dest /opt/ipkg/ /" >> /opt/ipkg/etc/ipkg.conf

PATH=$PATH:/opt/ipkg/bin:/opt/ipkg/sbin

echo "Bootstraping done"

echo "Installing glibc-locale package to generate needed /opt/lib/locale/locale-archive"
echo "================================================================================="

/opt/ipkg/bin/ipkg update
/opt/ipkg/bin/ipkg install glibc-locale

echo "================================================================================="
echo "Removing glibc-locale package to save space: this doesn't remove generated /opt/lib/locale/locale-archive"

/opt/ipkg/bin/ipkg remove glibc-locale
