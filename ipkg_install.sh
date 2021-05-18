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

echo "Updatting list of available packages"
echo "======================================================================================"
mkdir -p /opt/ipkg/opt/var/lock/
/opt/ipkg/bin/ipkg -o /opt/ipkg/ update

echo "Installing glibc-locale package to generate needed /opt/ipkg/lib/locale/locale-archive"
echo "======================================================================================"
/opt/ipkg/bin/ipkg -o /opt/ipkg/ install glibc-locale

echo "======================================================================================"
echo "Removing glibc-locale package to save space: this doesn't remove generated /opt/ipkg/lib/locale/locale-archive"
/opt/ipkg/bin/ipkg -o /opt/ipkg/ remove glibc-locale


echo "======================================================================================"
/opt/ipkg/bin/ipkg -o /opt/ipkg/ install gcc

echo "======================================================================================"
/opt/ipkg/bin/ipkg -o /opt/ipkg/ install make

echo "======================================================================================"
/opt/ipkg/bin/ipkg -o /opt/ipkg/ install python27

echo "======================================================================================"
/opt/ipkg/bin/ipkg -o /opt/ipkg/ install py27-pip
