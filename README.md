# Alpine Linux on Kindle
Here you find a set of utilities to get [Alpine Linux](https://alpinelinux.org/) running on Kindles. So far this has been tested on Paperwhite 3 only, but it should work on any Kindle (not Kindle Fire though) that has a touchscreen and enough Flash/RAM (At least enough space beside your books/documents to save a >=1.5GB file and at least 512MiB RAM).

![alt text](https://github.com/schuhumi/alpine_kindle/raw/master/images/Kindle_Alpine_Chromium.jpg)

## Overview
Kindles run a Linux operating system with X11 and everything on board already. To make better use of that one can utilize a full blown Linux distro including a proper desktop environment through chroot. Your Kindle stays fully functional to buy & read books. There's a number of things you need to get started though:
1. A rooted Kindle, you should have Kual, Kterm and USBNetwork working
2. An image file with Alpine Linux in it. You can either use the script provided here to quicky create a fresh and up-to-date one, or just download a snapshot from [TODO]
3. A two more scripts found in here to start Alpine on the kindle

## Step-by-Step
### 1. Root your Kindle
How that exactly works depends on your model of Kindle as well as the firmware version. You can find more information in the [mobileread forums](https://www.mobileread.com/forums/forumdisplay.php?f=150) and [mobileread wiki](https://wiki.mobileread.com/wiki/Kindle_Touch_Hacking). You'll also need [KUAL](https://www.mobileread.com/forums/showthread.php?t=203326) as application launcher, [Kterm](https://www.fabiszewski.net/kindle-terminal/) to start Alpine on the go without a computer, and [USBNetworking](https://wiki.mobileread.com/wiki/Kindle_Touch_Hacking#USB_Networking) for SSH access during installation.

### 2. Get an Alpine image
Here Alpine is saved within a file. You can either download an image at [TODO RELEASES], or create your own fresh and possibly customized one with the help of a script. Creating your own doesn't take long either, and if you have a linux computer it's pretty easy. All you need to install is qemu-user-static to execute arm software, but that should be in the repositories of your distro in most cases. Then have a look at [the script](https://github.com/schuhumi/alpine_kindle/blob/master/create_kindle_alpine_image.sh) especially at the configuration part (top). Finally you can execute it, and after a very short while you should be dropped into a shell inside Alpine. You can have a look around and tweak whatever you want, and with "exit" the script unmounts your fresh image and terminates.

### 3. Put it on your Kindle
First make sure you have enough space on your Kindle (The default size for alpine.ext3 is 2.0GB), you can check through SSH or using Kterm like so:
```
[root@kindle root]# df -h /mnt/us
Filesystem                Size      Used Available Use% Mounted on
fsp                       3.0G    530.8M      2.5G  17% /mnt/us
```
If you delete files to make room "df -h" may not update accordingly, reboot your Kindle then (you can use the "reboot" command).

You need to copy the Alpine image (must be named "alpine.ext3"!), the alpine.sh script and alpine.conf upstart-script on to the kindle. You can copy them on there like you do with other documents (USB mass storage, just put them in to root folder), or via scp in the following fashion (You need to have USBNetwork enabled obviously):
```
scp -C alpine.ext3 root@192.168.15.244:/mnt/us/
scp alpine.sh root@192.168.15.244:/mnt/us/
scp alpine.conf  root@192.168.15.244:/mnt/us/
```
To save on RAM the Kindle GUI can be stopped before Alpine gets started. That must be done through upstart though, because when you stop the Kindle GUI, so does Kterm and Alpine itself when you start it from there. "alpine.conf" is a script to allow for that, it must be copied to the appropriate place though (using SSH or Kterm), e.g. assuming you have put it into /mnt/us:
```
mntroot rw
cp /mnt/us/alpine.conf /etc/upstart/
mntroot r
```
### 4. Run it
*********************
#### !!WARNING!!
WHILE ALPINE IS RUNNING / THE IMAGE IS MOUNTED, DO NOT CONNECT YOUR KINDLE TO THE COMPUTER WITHOUT USBNETWORK ENABLED! The image resides in /mnt/us, and that is your usb mass storage location. When Alpine and the computer write on the userstore partition (partition 4) at the same time, it will be destroyed, and you need to fix that partition to get your Kindle working again. It might even be possible to brick the Kindle!!! Kual has an option to show the USBNetwork status, so check that beforehand if you plan on doing SSH while Alpine runs.
*********************
For running Alpine you have two options:
1. In Kterm, first run "sh alpine.sh" in the "/mnt/us" folder. That drops you into an Alpine shell, where you can do text based stuff, or run "sh startgui.sh" to start the desktop
2. You can use upstart to save on ram, for that run "start alpine" from Kterm. It will bring you to the desktop immediately.

You can do both options over SSH as well.

### 5. Customize it
