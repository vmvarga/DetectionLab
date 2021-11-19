#! /usr/bin/env bash

# https://serverfault.com/questions/48724/100-non-interactive-debian-dist-upgrade
sudo ip link set eth1 down && sudo ip link set eth1 up
#sudo export DEBIAN_FRONTEND=noninteractive
#sudo export APT_LISTCHANGES_FRONTEND=none
#sudo apt-get update && sudo apt-get -o Dpkg::Options::="--force-confnew" upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages && sudo apt-get -o Dpkg::Options::="--force-confnew" dist-upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
sudo apt-get update && sudo apt-get install exploitdb
mkdir ~/Desktop/Learning && cd ~/Desktop/Learning
git clone https://github.com/sbousseaden/PCAP-ATTACK.git PCAP_sample
chmod +x /home/vagrant/kali_installsilk.sh && /home/vagrant/kali_installsilk.sh