#!/bin/sh
mkdir -p /tmp/alpine
mount -o loop,noatime -t ext3 /mnt/base-us/alpine.ext3 /tmp/alpine
mount -o bind /dev /tmp/alpine/dev
mount -o bind /dev/pts /tmp/alpine/dev/pts
mount -o bind /proc /tmp/alpine/proc
mount -o bind /sys /tmp/alpine/sys
cp /etc/hosts /tmp/alpine/etc/hosts
cp /etc/resolv.conf /tmp/alpine/etc/resolv.conf

chroot /tmp/alpine /bin/sh

kill -9 $(lsof -t /var/tmp/alpine/)

umount /tmp/alpine/sys
umount /tmp/alpine/proc
umount /tmp/alpine/dev/pts
umount /tmp/alpine/dev
umount /tmp/alpine

