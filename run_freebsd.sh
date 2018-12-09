#!/usr/bin/env bash

sh /usr/share/examples/bhyve/vmrun.sh \
    -t tap0 \
    -d /usr/home/alex/workspace/vms/disk.img \
    -I /usr/home/alex/workspace/vms/FreeBSD-11.2-RELEASE-amd64-bootonly.iso \
    freebsd
