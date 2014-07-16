#!/system/xbin/env ash

CHROOT="/data/arch"

echo "Downloading official BusyBox from busybox.net..."
mkdir -p "/data/local/tmp/arch/"
busybox wget http://busybox.net/downloads/binaries/latest/busybox-armv7l -O "/data/local/tmp/arch/arch-busybox" || exit 1
chmod 777 "/data/local/tmp/arch/archbusybox"
busybox="/data/local/tmp/arch/archbusybox"

echo "Downloading ArchLinuxARM-trimslice-latest.tar.gz..."
$archbusybox wget -c http://nl.mirror.archlinuxarm.org/os/ArchLinuxARM-trimslice-latest.tar.gz || exit 1

echo "Making 4GB image..."
$archbusybox dd if=/dev/zero of=${CHROOT}.img bs=1M seek=4096 count=1 || exit 1

echo "Formatting image..."
$archbusybox mke2fs -L arch-image -F ${CHROOT}.img || exit 1
$archbusybox mkdir ${CHROOT}

echo "Making devices..."
$archbusybox mknod /dev/loop256 b 7 256 || exit 1
$archbusybox losetup /dev/loop256 ${CHROOT}.img || exit 1

echo "Mounting file systems..."
$archbusybox mount -t ext4 -o rw,noatime /dev/block/loop256 ${CHROOT} || exit 1

echo "Extracting Arch system into image..."
$archbusybox gunzip ArchLinuxARM-trimslice-latest.tar.gz -c | $archbusybox tar x -f - -C ${CHROOT} || exit 1

echo "Adding directories..."
$archbusybox mkdir -p ${CHROOT}/media/sdcard
$archbusybox mkdir -p ${CHROOT}/media/system
$archbusybox mkdir -p ${CHROOT}/dev/pts
$archbusybox mkdir ${CHROOT}/dev/ptmx

echo "Mounting extra file systems..."
$archbusybox mount -o bind /dev/ ${CHROOT}/dev || exit 1
$archbusybox mount -t proc proc ${CHROOT}/proc || exit 1
$archbusybox mount -t sysfs sysfs ${CHROOT}/sys || exit 1
$archbusybox mount -t devpts devpts ${CHROOT}/dev/pts || exit 1
$archbusybox mount -o bind /sdcard ${CHROOT}/media/sdcard || exit 1

echo "Installing packages and upgrading system..."
echo -e "nameserver 208.67.222.222\nnameserver 208.67.220.220" > ${CHROOT}/etc/resolv.conf
echo "nexus7" > ${CHROOT}/etc/hostname
$archbusybox rm -rf ${CHROOT}/opt/nvidia
$archbusybox rm -f ${CHROOT}/etc/ld.so.conf.d/nvidia-trimslice.conf
$archbusybox chroot ${CHROOT} /usr/bin/env HOME=/root TERM="$TERM" PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash -c "source /etc/profile; groupadd -g 3003 aid_inet; groupadd -g 3004 inet; groupadd -g 3005 inetadmin; usermod -aG inet root; usermod -aG inetadmin root; pacman -Syyu --noconfirm; pacman -S --noconfirm xorg-server xorg-xrdb tigervnc xterm xorg-xsetroot xorg-xmodmap rxvt-unicode dwm pkg-config dmenu fakeroot zsh emacs vim git tmux mosh ruby python3 python2 sudo wget rsync base-devel; pacman -Rdd --noconfirm linux-firmware"

echo "Exiting chroot, unmounting..."
umount ${CHROOT}/media/sdcard
umount ${CHROOT}/dev/pts
umount ${CHROOT}/proc
umount ${CHROOT}/sys

echo "Killing existing processes in chroot..."
$archbusybox fuser -mk ${CHROOT}
umount ${CHROOT}/dev
umount ${CHROOT}

echo "Deactivating loop..."
$archbusybox losetup -d /dev/loop256

#echo "Deleting ArchLinuxARM-trimslice-latest.tar.gz..."
#rm ArchLinuxARM-trimslice-latest.tar.gz