#!/usr/bin/env bash

if [ "${CD_IMAGE}" == "" ];  then
	CD_IMAGE=/usr/home/alex/workspace/vms/Fedora-Workstation-netinst-x86_64-29-1.2.iso
fi
if [ "${DISK}" == "" ]; then
	DISK=/usr/home/alex/workspace/vms/disk.img 
fi

bhyve \
    -c 2 \
    -m 1G \
    -w \
    -H \
    -s 0,hostbridge \
    -s 3,ahci-cd,${CD_IMAGE} \
    -s 4,ahci-cd,${DISK} \
    -s 5,virtio-net,tap0 \
    -s 29,fbuf,tcp=0.0.0.0:5900,w=1280,h=720,wait \
    -s 30,xhci,tablet \
    -s 31,lpc \
    -l com1,stdio \
    -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
    uefi
