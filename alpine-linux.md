# IsardVDI on Alpine Linux (3.8.1)

## Packages
```
apk add docker py-pip mdadm
pip install docker-compose
```

## Fix cgroups
```
mkdir -p /sys/fs/cgroup/systemd
echo 'cgroup /sys/fs/cgroup/systemd/ cgroup none,name=systemd' >> /etc/fstab
```
Mount it temporarily
```
mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd/
```

## Add tun module
```
echo 'tun' >> /etc/modules
```

## Add raid module
```
echo 'raid1' >> /etc/modules
rc-update add mdadm boot
rc-update add mdadm-raid boot
```

## Start docker service
```
rc-update add docker
```

## Clone repo
```
git clone https://github.com/isard-vdi/isard-docker
cd isard-docker
docker-compose up
```
