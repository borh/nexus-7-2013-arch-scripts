#!/system/xbin/env ash

unset _chroot
_chroot="/data/arch"
unset _tmp
_tmp="/sdcard/losetup.txt"
unset _rootfsimage
_rootfsimage="${_chroot}.img"

# Checking if losetup is done
busybox [ -e "$_tmp" ] && rm -f $_tmp
busybox losetup > $_tmp
unset _line

echo >> "$_tmp"
while read _line; do
   case "$_line" in
      *"arch.img"* )
         echo "Loop found."
         break
      ;;
      * )
         echo "Setting up loop"...
         busybox mknod /dev/loop256 b 7 256 || echo "/dev/loop256 already exists, skipping..."
         busybox losetup /dev/loop256 ${_rootfsimage} || exit 1
      ;;
   esac
done < $_tmp

echo "Mounting file systems..."
busybox mount -t ext4 -o rw,noatime /dev/block/loop256 $_chroot || exit 1
busybox mount -o bind /dev/ $_chroot/dev || exit 1
busybox mount -t proc proc $_chroot/proc || exit 1
busybox mount -t sysfs sysfs $_chroot/sys || exit 1
busybox mount -t devpts devpts $_chroot/dev/pts || exit 1
busybox mount -o bind /sdcard $_chroot/media/sdcard || exit 1
busybox mount -o bind /system $_chroot/media/system || exit 1

USER=$1

echo "Entering chroot..."
CHROOT_SETUP="export TERM=xterm-256color; mount -t proc proc /proc; mount -t sysfs sysfs /sys; ln -s /proc/self/fd /dev/fd; source /etc/profile; clear"

case $USER in
    *"root"* )
        busybox chroot $_chroot /usr/bin/env HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash -c "${CHROOT_SETUP}; /bin/bash"
    ;;
    * )
        busybox chroot $_chroot /usr/bin/env HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash -c "export HOME=/home/${USER}; ${CHROOT_SETUP}; su - ${USER}"
    ;;
esac

echo "chroot exited. umount..."
umount $_chroot/media/sdcard || exit 1
umount $_chroot/media/system || exit 1
umount $_chroot/dev/pts || exit 1
umount $_chroot/proc || exit 1
umount $_chroot/sys || exit 1
echo "killing existing processes in chroot..."
busybox fuser -mk $_chroot
umount $_chroot/dev || exit 1
umount $_chroot || exit 1
echo "Deactivating loop..."
busybox losetup -d /dev/loop256
echo "Done. Bye!"
busybox [ -e "$_tmp" ] && rm -f $_tmp
exit 0
