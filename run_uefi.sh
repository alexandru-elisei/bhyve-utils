#!/usr/bin/env bash

if [ "${CD_IMAGE}" == "" ];  then
	CD_IMAGE=Fedora-Server-netinst-x86_64-29-1.2.iso
fi
if [ "${DISK}" == "" ]; then
	DISK=disk.img 
fi

if [ "$1" != "--no_cd" ]; then
	cd_opt="-s 2,ahci-cd,${CD_IMAGE}"
else
	cd_opt=""
fi

bhyve \
    -c 2 \
    -m 2G \
    -w \
    -H \
    -s 0,hostbridge \
    -s 1,virtio-blk,${DISK} \
    ${cd_opt} \
    -s 5,virtio-net,tap0 \
    -s 29,fbuf,tcp=0.0.0.0:5900,w=1280,h=720,wait \
    -s 30,xhci,tablet \
    -s 31,lpc \
    -l com1,stdio \
    -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
    uefi

bhyvectl --destroy --vm=uefi
