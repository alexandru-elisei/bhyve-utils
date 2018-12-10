#!/usr/bin/env bash

bhyveload \
	-c stdio \
	-m 512M \
	-d FreeBSD-11.2-RELEASE-amd64-bootonly.iso \
	freebsd

if [[ "$?" != "0" ]]; then
	exit 1
fi

bhyve \
	-c 2 \
	-m 512M \
	-HAP \
	-s 0,hostbridge \
	-s 1,lpc \
	-s 2,virtio-net,tap0 \
	-s 3,virtio-blk,disk.img \
	-s 4,ahci-cd,FreeBSD-11.2-RELEASE-amd64-bootonly.iso \
	-l com1,stdio \
	freebsd

bhyvectl --destroy --vm=freebsd
