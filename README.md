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
