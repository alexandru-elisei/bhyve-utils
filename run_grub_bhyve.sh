#!/usr/bin/env bash

grub-bhyve \
	-m /usr/local/alex/workspace/vms/device.map \
	-M 1024M \
	grub_bhyve

if [[ "$?" != "0" ]]; then
	exit 1

bhyve -AHP \
	-s 0:0,hostbridge \
	-s 1:0,lpc \
	-s 2:0,virtio-net,tap0 \
	-s 3:0,virtio-blk,disk.img \
	-s 4:0,ahci-cd,Fedora-Workstation-netinst-x86_64-29-1.2.iso \
	-l com1,stdio \
	-c 4 \
	-m 1024m \
	grub_bhyve

if [[ "$?" != "0" ]]; then
	exit 1

bhyvectl --destroy --vm=grub_bhyve
