#!/bin/sh

ALREADYMOUNTED="no"
if [ "$(mount | grep /tmp/alpine)" ] ; then
	ALREADYMOUNTED="yes"
	echo "ATTENTION! Alpine's rootfs is already mounted, thus you will be just dropped into it."
	echo "BE CAREFUL to leave this shell first, as there will be no umount either (To not disturb the other session)."
   else
	echo "Mounting Alpine rootfs"
	mkdir -p /tmp/alpine
	mount -o loop,noatime -t ext3 /mnt/base-us/alpine.ext3 /tmp/alpine
	mount -o bind /dev /tmp/alpine/dev
	mount -o bind /dev/pts /tmp/alpine/dev/pts
	mount -o bind /proc /tmp/alpine/proc
	mount -o bind /sys /tmp/alpine/sys
	mount -o bind /var/run/dbus/ /tmp/alpine/run/dbus/
	cp /etc/hosts /tmp/alpine/etc/hosts
	chmod a+w /dev/shm
fi

echo "You're now being dropped into Alpine's shell"
chroot /tmp/alpine /bin/sh

if [ $ALREADYMOUNTED = "yes" ] ; then
	echo "Umount is being skipped, as the rootfs was mounted already. You're now at your kindle's shell again."
else
	echo "You returned from Alpine, killing remaining processes"
	kill $(pgrep Xephyr)
	kill -9 $(lsof -t /var/tmp/alpine/)

	echo "Unmounting Alpine rootfs"
	LOOPDEV="$(mount | grep loop | grep /tmp/alpine | cut -d" " -f1)"
	umount /tmp/alpine/run/dbus/
	umount /tmp/alpine/sys
	sleep 1
	umount /tmp/alpine/proc
	umount /tmp/alpine/dev/pts
	umount /tmp/alpine/dev
	# Sync beforehand so umount doesn't fail due to the device being busy still
	sync
	umount /tmp/alpine || true
	# Sometimes it fails still and only works by trying again
	while [ "$(mount | grep /tmp/alpine)" ]
	do
		echo "Alpine is still mounted, trying again shortly.."
		sleep 3
		umount /tmp/alpine || true
	done
	echo "Alpine unmounted"
	echo "Disassociating loop device >>$LOOPDEV<<"
	losetup -d $LOOPDEV
	echo "All done, you're now back at your kindle's shell."
fi

