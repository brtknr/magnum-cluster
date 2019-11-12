#!/usr/bin/env bash
export kube_tag=${kube_tag:-v1.16.0}
export os_distro=fedora-atomic
export action=upgrade
export extra_labels=",ostree_remote=fedora/29/x86_64/atomic-host,ostree_commit=1766b4526f1a738ba1e6e0a66264139f65340bcc28e7045f10cbe6d161eb1925"
export ctprefix=k8s-upgrade
bash `dirname $0`/site.sh
