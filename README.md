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

To enter as root:

```bash
nexus7 $ su
nexus7 $ sh /sdcard/chroot.sh
```

To enter as user XYZ:

```bash
nexus7 $ su
nexus7 $ sh /sdcard/chroot.sh XYZ
```

### Adding users

Add user XYZ:

```bash
chroot $ export USER=XYZ
chroot $ useradd -m -g users -s /bin/zsh ${USER} # or /bin/bash...
chroot $ usermod -aG inet ${USER}
chroot $ usermod -aG inetadmin ${USER}
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

### VNC Client

Recommend downloading and installing androidVNC from here: http://dl.dropbox.com/u/13927052/androidVNC-branch_antlersoft_eeePadBuild_004.apk
