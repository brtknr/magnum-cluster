#!/usr/bin/env bash
export kube_tag=${kube_tag:-v1.16.1}
export os_distro=fedora-atomic
export action=upgrade
bash `dirname $0`/site.sh
