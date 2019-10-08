#!/bin/bash
IMAGE=${IMAGE:-Fedora-Atomic-27-20180419.0}
ARCH=${ARCH:-x86_64}
curl -OL https://download.fedoraproject.org/pub/alt/atomic/stable/$IMAGE/CloudImages/x86_64/images/$IMAGE.$ARCH.qcow2
openstack image create \
     --disk-format=qcow2 \
     --container-format=bare \
     --file=$IMAGE.$ARCH.qcow2\
     --property os_distro='fedora-atomic' \
     $IMAGE.$ARCH
