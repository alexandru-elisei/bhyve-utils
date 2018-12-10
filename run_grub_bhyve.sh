#!/usr/bin/env bash

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
	-s 2:0,virtio-net,tap0 \
	-s 3:0,virtio-blk,disk.img \
	-s 4:0,ahci-cd,Fedora-Xfce-Live-x86_64-29-20181029.iso \
	-l com1,stdio \
	-c 2 \
	-m 2048M \
	grub_bhyve

bhyvectl --destroy --vm=grub_bhyve
