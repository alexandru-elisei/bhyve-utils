#!/usr/bin/env bash

if [ "${CD_IMAGE}" == "" ];  then
	CD_IMAGE=Fedora-Xfce-Live-x86_64-29-20181029.iso
fi
if [ "${DISK}" == "" ]; then
	DISK=disk.img 
fi

bhyve \
    -c 2 \
    -m 2G \
    -w \
    -H \
    -s 0,hostbridge \
    -s 1,virtio-blk,${DISK} \
    -s 3,ahci-cd,${CD_IMAGE} \
    -s 5,virtio-net,tap0 \
    -s 29,fbuf,tcp=0.0.0.0:5900,w=1280,h=720,wait \
    -s 30,xhci,tablet \
    -s 31,lpc \
    -l com1,stdio \
    -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
    uefi
