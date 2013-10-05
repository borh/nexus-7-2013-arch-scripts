#!/bin/bash

rm ~/.vnc/localhost* > /dev/null 2>&1

vncserver :0 -geometry 1920x1120
dbus-daemon --system --fork > /dev/null 2>&1

echo
echo "If you see the message 'New 'X' Desktop is localhost:0' then you are ready to VNC into your ArchArm OS.."
echo
echo "If VNC'ing from a different machine on the same network as the android device use the 1st address below:"
ifconfig | grep "inet addr"

echo
echo "If using androidVNC, change the 'Color Format' setting to 24-bit colour, and once you've VNC'd in, change the 'input mode' to touchpad (in settings)"

echo
echo "To shut down the VNC server and exit the ArchArm environment, just enter 'exit' at this terminal - and WAIT for all shutdown routines to finish!"
echo

/bin/bash -i
vncserver -kill :0
