sudo yum install nano git dnsmasq -y
sudo cp etc/dnsmasq.d/cube.conf /etc/dnsmasq.d/
sudo systemctl enable dnsmasq

sudo cp etc/udev/rules.d/* /etc/udev/rules.d/
sudo mv /etc/sysconfig/network-scripts/ifcfg-* backup/
sudo cp etc/sysconfig/network-scripts/ifcfg-* /etc/sysconfig/network-scripts/

sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --zone=public --add-port=67/udp --permanent
sudo firewall-cmd --zone=public --add-port=53/udp --permanent
sudo firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o wan -j MASQUERADE -s 172.31.0.0/16 
sudo firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -o wan -j ACCEPT

echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/99-sysctl.conf 
reboot
