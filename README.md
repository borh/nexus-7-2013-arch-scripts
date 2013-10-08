# nexus-7-2013-arch-scripts

A set of scripts to manage an Arch Linux chroot on the 2013 model Nexus 7

## Prerequisites

A rooted Nexus 7 (only 2013 model tested).

## Initial install

Clone the repo and get inside:

```bash
local $ git clone https://github.com/borh/nexus-7-2013-arch-scripts.git
local $ cd nexus-7-2013-arch-scripts
```

From here on out, the following naming conventions wil be used:

-   _local_: your local machine
-   _nexus7_: inside the Nexus 7 Android environment
-   _chroot_: inside the chroot (Arch) inside the Nexus 7 Android environment

Copy the install script and get an android shell:

```bash
local $ adb push install-arch.sh /sdcard/
local $ adb shell
```

Install arch:

```bash
nexus7 $ su
nexus7 $ sh /sdcard/install-arch.sh
```

## chroot script

```bash
local $ adb push chroot.sh /sdcard/
```

To enter as `root`:

```bash
nexus7 $ su
nexus7 $ sh /sdcard/chroot.sh root
```

To enter as user `XYZ` (after you have created a user, as detailed in the next section):

```bash
nexus7 $ su
nexus7 $ sh /sdcard/chroot.sh XYZ
```

### Adding users

Add user `XYZ`:

```bash
chroot $ export USER=XYZ
chroot $ useradd -m -g users -s /bin/zsh ${USER} # or /bin/bash...
chroot $ usermod -aG inet ${USER}
chroot $ usermod -aG inetadmin ${USER}
chroot $ usermod -aG aid_inet ${USER}
chroot $ usermod -aG wheel ${USER}
chroot $ visudo # uncomment %wheel ALL=(ALL) ALL
```

## VNC script (Standalone)

```bash
chroot $ mkdir ~/.vnc
chroot $ cp /media/sdcard/xstartup ~/.vnc
chroot $ cp /media/sdcard/init-vnc.sh ~/
chroot $ ~/init-vnc.sh
```

Before starting the VNC server, we want to configure dwm:

```bash
chroot $ cd nexus-7-2013-arch-scripts/builds
chroot $ cd cower && makepkg -i && cd ..
chroot $ cd pacaur && makepkg -i && cd ..
chroot $ cd dwm && makepkg -i && cd ..
```

### VNC Client

Recommend downloading and installing androidVNC from here: http://dl.dropbox.com/u/13927052/androidVNC-branch_antlersoft_eeePadBuild_004.apk

Settings for software keyboard:

-  'Hacker Keyboard' from Play Store

Settings for hardware keyboard:

-  'Tweaked Keyboard Layout' from Play Store
-  With androidVNC, the "Mouse Pointer Control Mode" passes through most of the keys

## References

Most of the hard work on installing Arch (chroot) on android has already been done by others.
These are just some of my personal modifications to their work.

-   http://archlinuxarm.org/forum/viewtopic.php?t=1361
-   http://rubiojr.rbel.co/hack/2013/01/10/installing-arch-linux-in-your-android-phone-chroot/
