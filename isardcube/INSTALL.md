# Install a machine as an IsardCube

NOTE: Not fully functional as not throughly tested yet!!

This procedure should be done in a new clean server. We used for this setup this mainboard: http://www.supermicro.com/products/motherboard/Xeon/D/X10SDV-6C-TLN4F.cfm

## Install Centos 7 

Install it from minimal ISO: https://www.centos.org/download/

During the install make sure to have enough space on /isard mountpoint. You have two options:

- You can put all your system on / (avoid /home defaults)
- Or you can put your speedy storage (NVME?) on a new mountpoint named /isard

NOTE: Mountpoint /isard will be used to store virtual desktops disks later.

## Clone isard-docker repo (this repo)

```
yum install git -y
git clone https://git clone https://github.com/isard-vdi/isard-docker.git
cd isard-docker
```

## Install docker & docker-compose

```
./centos7-install.docker.sh
cd isardcube
```

## Update network interface config

Your system should have at least two network interfaces:

- LAN: Use a 10G interface if available. All virtual desktops viewers will go through this interface. A dhcp & dns servers will be started on this interface and it will set IP address 172.31.0.1 on it. So it might be connected to your lan switch (through a 10G port?) where you plan to use the virtual desktops.
- WAN: A 1G interface it is enough if you don't plan to access many virtual desktops viewers through this interface. It will get IP from your dhcp so it might be connected to your Internet access (router?). Your isardCube machine will route normal traffic from LAN Interface to WAN. Your LAN computers will use also the same dns the dhcp served to isardCube on WAN interface. 

Optional:

- AP: Access point interface. It will be bridged with LAN so it will serve dhcp and dns as well.
- CONFIG: We use this as a backup interface to access isardCube by default. You can remove this one, not really needed.

## Interface names

Set interface names properly on etc/udev/rules.d (the etc inside isardcube folder!). The file will look like this:
```
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="0c:c4:7a:97:ca:ea", ATTR{type}=="1", KERNEL=="e*", NAME="lan"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="0c:c4:7a:97:ca:eb", ATTR{type}=="1", KERNEL=="e*", NAME="wan"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="0c:c4:7a:97:ca:87", ATTR{type}=="1", KERNEL=="e*", NAME="ap"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="0c:c4:7a:97:ca:86", ATTR{type}=="1", KERNEL=="e*", NAME="config"
```

As said, configure your mac addresses accordingly to your hardware and remove optional ones if not present.

## Set up isardCube

NOTE: Before doing this BE SURE that you put the correct mac addresses on the previous step.

Now you can run setup-isardcube.sh on isardcube folder. After that your isardCube will reboot.

When it has rebooted run **docker-compose up** inside this cloned repository and it will download images and start containers. 

IsardVDI should now be available on LAN (and AP if available) through any of this:

- https://172.31.0.1
- https://cube.isardvdi.com
- If none of the above worked you could try access through the IP gathered on WAN interface.

If it is still not accessible, check this:
- clients on LAN (and AP) are receiving adresses on range 172.31.0.0/24
- there are dockers running: docker ps
- selinux is disabled: getenforce  (should return 0)
- disable firewall: systemctl stop firewalld (it should be running and allowing access, but worth trying to disable it)
- try to reboot isardCube and see if interfaces got correct names (lan & wan) and dnsmasq service is running (systemctl status dnsmasq)


