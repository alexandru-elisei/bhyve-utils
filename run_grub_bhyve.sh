#!/usr/bin/env bash

if [ "${CD_IMAGE}" == "" ];  then
	CD_IMAGE=Fedora-Server-netinst-x86_64-29-1.2.iso
fi
if [ "${DISK}" == "" ]; then
	DISK=disk.img 
fi

if [ "$1" != "--no_cd" ]; then
	cd_opt="-s 3,ahci-cd,${CD_IMAGE}"
	load_img="${CD_IMAGE}"
else
	cd_opt=""
	load_img="${DISK}"
fi

grub-bhyve \
	-m device.map \
	-M 2048M \
	grub_bhyve

if [[ "$?" != "0" ]]; then
	exit 1
fi

bhyve -AHP \
	-s 0:0,hostbridge \
	-s 1:0,lpc \
	-s 2:0,virtio-blk,${DISK} \
	${cd_opt} \
	-s 4:0,virtio-net,tap0 \
	-l com1,stdio \
	-c 2 \
	-m 2048M \
	grub_bhyve

bhyvectl --destroy --vm=grub_bhyve
