#!/bin/bash

hcloud server ssh image-base <<EOF
    set -ex

    if ! grep -q /mnt /proc/mounts; then
        mount -o discard,defaults /dev/disk/by-uuid/72b29243-4053-462e-a6b1-8d5e585e5b8c /mnt
    fi

    cd /mnt

    if [ ! -e OL7U9_x86_64-olvm-b114.qcow2 ]; then
        curl -LO https://yum.oracle.com/templates/OracleLinux/OL7/u9/x86_64/OL7U9_x86_64-olvm-b114.qcow2
    fi

    qemu-img convert -f qcow2 -O raw OL7U9_x86_64-olvm-b114.qcow2 /dev/sda

    mkdir -p /media/image
    umount -R /media/image || true

    mount /dev/vg_main/lv_root /media/image

    cat >/media/image/etc/cloud/cloud.cfg.d/90-hetznercloud.cfg <<YAML
# Hetzner cloud-init defaults

# If this is set, 'root' will not be able to ssh in and they
# will get a message to login instead as the above \$user (debian)
disable_root: false

system_info:
   # Default user name + that default users groups (if added/used)
   default_user:
     name: root
     lock_passwd: True
     shell: /bin/bash

datasource_list: [ Hetzner, None ]
YAML
    cat /media/image/etc/cloud/cloud.cfg.d/90-hetznercloud.cfg

    (
        set -x
        echo nameserver 185.12.64.1
        echo nameserver 185.12.64.2
    ) >/media/image/etc/resolv.conf

    rm /media/image/etc/systemd/system/multi-user.target.wants/firewalld.service

    umount -R /media/image
EOF
