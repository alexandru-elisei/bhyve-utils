#!/usr/bin/env bash

if [ "${CD_IMAGE}" == "" ];  then
	CD_IMAGE=FreeBSD-11.2-RELEASE-amd64-disc1.iso
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

bhyveload \
	-c stdio \
	-m 2048M \
	-d ${load_img} \
	freebsd

if [[ "$?" != "0" ]]; then
	exit 1
fi

bhyve \
	-c 2 \
	-m 2048M \
	-HAP \
	-s 0,hostbridge \
	-s 1,lpc \
	-s 2,virtio-blk,${DISK_IMAGE} \
	${cd_opt} \
	-s 4,virtio-net,tap0 \
	-l com1,stdio \
	freebsd

bhyvectl --destroy --vm=freebsd

