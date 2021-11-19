#!/bin/bash
# These version are in lock-step together.  If you update one, be sure to go to the SiLK site and
# get the required versions for the others.
SILK_VER=3.18.3
YAF_VER=2.11.0
LIBFXBUF_VER=2.4.0
AFTERGLOW_VER=1.6.5

# The SNIF_CIDR subnet is the where you want to monitor traffic.
# The NAT_CIDR is for general internet related work, or to SSH into it.
SNIFF_CIDR=192.168.56.0/24
NAT_CIDR=10.0.2.0/24

# These don't likely need to be changed.
LISTEN_PORT=18001
LISTEN_AS_HOST=127.0.0.1

# Get the required modules to install, Libfixbuf, Yaf, and SiLK
wget -N https://tools.netsa.cert.org/releases/silk-${SILK_VER}.tar.gz
wget -N https://tools.netsa.cert.org/releases/yaf-${YAF_VER}.tar.gz
wget -N https://tools.netsa.cert.org/releases/libfixbuf-${LIBFXBUF_VER}.tar.gz
git clone https://github.com/zrlram/afterglow.git afterglow-${AFTERGLOW_VER}
wget -N https://tools.netsa.cert.org/releases/isilk-0.6.2.tar.gz
#wget -N https://students.cs.uri.edu/~forensics/courses/CSF536/lesson9/afterglow-${AFTERGLOW_VER}.tar.gz


# Need to make sure some of the build tools are available, because this script
# can be run on a clean linux (ubunty flavor) and some of the dependencies may not
# be installed out of the box.
#sudo apt-get install -y g++ libgtk2.0-dev libglib2.0-dev build-essential pkg-config libfixbuf3 libfixbuf3-dev libpcap0.8-dev python-dev
#sudo apt-get install -y libpython2-dev libfixbuf-dev libfixbuf9
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libpython2-dev libfixbuf-dev libfixbuf9
#sudo apt-get -q -y -o Dpkg::Options::="--force-confnew" install libpython2-dev libfixbuf-dev libfixbuf9 --allow-downgrades --allow-remove-essential --allow-change-held-packages
# Release hounds.
tar -xf silk-${SILK_VER}.tar.gz
tar -xf yaf-${YAF_VER}.tar.gz
tar -xf libfixbuf-${LIBFXBUF_VER}.tar.gz
tar -xf isilk-0.6.2.tar.gz
#tar -xf afterglow-${AFTERGLOW_VER}.tar.gz

# Install the prereq package for both yaf and silk.
cd ./libfixbuf-${LIBFXBUF_VER}
./configure && make && sudo make install

# Install YAF, making sure to set the libfixbuf correctly
cd ../yaf-${YAF_VER}
./configure --with-libfixbuf=/usr/local/lib/pkgconfig/ && make && sudo make install

# Install SILK, also to set the libfixbuf and enable python
cd ../silk-${SILK_VER}
./configure --with-libfixbuf=/usr/local/lib/pkgconfig/ --enable-ipv6 --with-python && make && sudo make install

#### We'll remain in the ~/silk-${SILK_VER} directory for the remainder of this flight.
# This will be where everything is stored.
sudo mkdir -p /data

# So we don't have to set this every time..
cat <<EOF >>silk.conf
/usr/local/lib
/usr/local/lib/silk
EOF
sudo mv silk.conf /etc/ld.so.conf.d/

# Enable the silk.conf
sudo ldconfig

# Start setting up our sensor
sudo cp site/twoway/silk.conf /data

# Configure our sensor, be sure to adjust the IP blocks as needed.
cat <<EOF >>sensors.conf
probe S0 ipfix
 listen-on-port ${LISTEN_PORT} # you may need to allow this port through the firewall so that yaf can talk to it
 protocol tcp
 listen-as-host ${LISTEN_AS_HOST}
end probe

group my-network
 ipblocks ${SNIFF_CIDR} # Sniffing
 ipblocks ${NAT_CIDR} # address of the NAT adapter
end group

sensor S0
 ipfix-probes S0
 internal-ipblocks @my-network
 external-ipblocks remainder
end sensor
EOF

# Move over the sendor config
sudo cp sensors.conf /data

# Create a new rwflowpack configuration from the stock provided by silk.
# NOTE: The filter data types (inweb, outweb, etc.) need to be in the same
# NOTE: directory as the silk.conf file, otherwise rwfilter can't reference
# NOTE: the sensor by name (i.e., --sensor=S0).
pwd
cat /usr/local/share/silk/etc/rwflowpack.conf | \
sed 's/ENABLED=/ENABLED=yes/#;' | \
sed 's#statedirectory=.*#statedirectory=/data/#;' | \
sed 's#CREATE_DIRECTORIES=.*#CREATE_DIRECTORIES=yes#;' |\
sed 's#SENSOR_CONFIG=#SENSOR_CONFIG=/data/sensors.conf#;' | \
sed 's#DATA_ROOTDIR=.*#DATA_ROOTDIR=/data/#;' | \
sed 's#SITE_CONFIG=#SITE_CONFIG=/data/silk.conf#;' | \
sed 's#LOG_TYPE=syslog#LOG_TYPE=legacy#;' | \
sed 's#LOG_DIR=.*#LOG_DIR=/var/log/#;'  \
>> rwflowpack.conf

# Copy over the rwflowpack configuration
sudo cp rwflowpack.conf /usr/local/etc/rwflowpack.conf
#sudo cp rwflowpack.conf /data/

# Backup the config file
sudo mv rwflowpack.conf rwflowpack.conf.bk

# Setup the daemon
sudo cp /usr/local/share/silk/etc/init.d/rwflowpack /etc/init.d

# This is a strange find/replace...but if you don't do it rwflowpack
# wont' stay running.
#sudo sed -i 's#DEFAULT_SCRIPT_CONFIG_LOCATION=#DEFAULT_SCRIPT_CONFIG_LOCATION=/data#;' /etc/init.d/rwflowpack

# Configure the daemon startup settings
sudo sudo update-rc.d rwflowpack start 20 3 4 5 .

# Startup the sensor
sudo service rwflowpack start


# Cleanup any setup files
#rm -rf ~/*
