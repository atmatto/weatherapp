#!/bin/bash

export IMAGE="ubuntu-24.04-minimal-cloudimg-amd64.img"

if [[ $1 == 'setup' ]]; then
    if [[ -e $IMAGE ]]; then
        echo "Image already exists, not downloading"
    else
        wget "http://cloud-images.ubuntu.com/minimal/releases/noble/release/$IMAGE"
    fi
    genisoimage -output seed.img -V cidata -r -J user-data meta-data 
    exit 0
elif [[ $1 == 'run' ]]; then
    echo $IMAGE
    if [[ ! -e $IMAGE ]]; then
        echo "Disk image does not exist"
        exit 1
    fi
    qemu-system-x86_64 \
        -enable-kvm \
        -machine q35 \
        -m 1024 \
        -nic user,hostfwd=tcp::2222-:22,hostfwd=tcp::2280-:80 \
        -drive if=virtio,format=qcow2,file=$IMAGE \
        -drive if=virtio,format=raw,file=seed.img \
        -snapshot
else
    echo -e "usage:\n\t$0 setup\n\t$0 run"
    exit 1
fi
