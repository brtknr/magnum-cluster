#!/bin/bash
DATE=30.20190905.0
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack}
ARCH=${ARCH:-x86_64}
curl -OL https://builds.coreos.fedoraproject.org/prod/streams/testing/builds/$DATE/$ARCH/$IMAGE.qcow2.xz
unxz $IMAGE.qcow2.xz
openstack image create \
     --disk-format=qcow2 \
     --container-format=bare \
     --file=$IMAGE.qcow2 \
     --property os_distro='fedora-coreos' \
     $IMAGE

