# IsardCube
Based on:
- CentOS 7
- Four network card mainboard. (You could set it up with only two interfaces: **wan** and **lan**)

## Interfaces

```
[root@isardcube network-scripts]# cat ifcfg-ap
DEVICE="ap"
TYPE="Ethernet"
NAME="ap"
HWADDR="12:34:56:78:9a:bc"
ONBOOT="yes"
BOOTPROTO="none"
BRIDGE=br-aplan
[root@isardcube network-scripts]# cat ifcfg-br-aplan
DEVICE=br-aplan
TYPE=Bridge
IPADDR=172.31.0.1
NETMASK=255.255.0.0
ONBOOT=yes
BOOTPROTO=none
DELAY=0

[root@isardcube network-scripts]# cat ifcfg-config
TYPE=Ethernet
BOOTPROTO=no
DEFROUTE=no
PEERDNS=no
PEERROUTES=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
DEVICE=config
NAME=config
ONBOOT=yes
AUTOCONNECT_PRIORITY=-999
IPADDR=172.31.31.31
NETMASK=255.255.255.0

[root@isardcube network-scripts]# cat ifcfg-lan
DEVICE="lan"
TYPE="Ethernet"
NAME="lan"
HWADDR="22:34:56:78:9a:bc"
ONBOOT="yes"
BOOTPROTO="none"
BRIDGE=br-aplan

[root@isardcube network-scripts]# cat ifcfg-wan
DEVICE="wan"
HWADDR="32:34:56:78:9a:bc"
ONBOOT="yes"
BOOTPROTO="dhcp"

```

## Selinux
```
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
```

## dnsmasq
```
# DHCP
bind-interfaces
interface=br-aplan
listen-address=172.31.0.1
dhcp-range=br-aplan,172.31.1.0,172.31.255.254,4h
dhcp-option=option:router,172.31.0.1
# STATIC LEASES
#dhcp-host=a2:34:56:78:9a:bc,172.31.0.2
#dhcp-host=b2:34:56:78:9a:bc,172.31.0.3

# RESOLVE ALL TO CUBE
address=/cube.isardvdi.com/172.31.0.1
address=/cube/172.31.0.1
#address=/#/172.31.0.1
```

## Ip forwarding
```
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/99-sysctl.conf
```

## Firewall
```
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --zone=public --add-port=67/udp --permanent
firewall-cmd --zone=public --add-port=53/udp --permanent
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o wan -j MASQUERADE -s 172.31.0.0/16 
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -o wan -j ACCEPT

```
