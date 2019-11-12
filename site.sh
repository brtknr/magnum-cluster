set -x

kube_tag=${kube_tag:-v1.14.8}
plugins=${plugins:-flannel calico}
nodes=${nodes:-2}
prefix=${prefix:-k8s}
ctprefix=${ctprefix:-k8s}

if [ "$minimal" == "true" ]; then
    focus="should provide DNS for services" # minimal test
fi

if [ "$action" != "destroy" ]; then
    image=${image:-`openstack image list --property os_distro=$os_distro -f value -c Name | tail -n1`}
fi

for nd in $plugins; do
    name=$prefix-$nd-$os_distro
    ctname=$ctprefix-$nd-$os_distro-$kube_tag
    if [ "$action" != "destroy" ]; then
        if [[ -z $(openstack coe cluster template list | grep $ctname) ]]; then
            openstack coe cluster template create --floating-ip-enabled --external-network public --image $image --flavor ds2G --master-flavor ds2G --fixed-network=private --fixed-subnet=private-subnet --docker-storage-driver overlay2 --coe kubernetes --network-driver $nd --labels heat_container_agent_tag=689704,kube_tag=$kube_tag$extra_labels --dns-nameserver 1.1.1.1 $ctname
        fi
    fi
    if [ "$action" == "create" ]; then
        if [[ -z $(openstack coe cluster list | grep COMPLETE | grep $name) ]]; then
            openstack coe cluster create --keypair `hostname` --master-count 1 --node-count $nodes --cluster-template $ctname $name
        fi
    elif [ "$action" == "upgrade" ]; then
        openstack coe cluster upgrade $name $ctname
    elif [ "$action" == "sonobuoy" ]; then
        openstack coe cluster config $name --dir ~/.kube --force
        sonobuoy delete --wait
        sonobuoy run --e2e-focus "$focus"
    elif [ "$action" == "destroy" ]; then
        openstack coe cluster delete $name
        while [[ -z "$(openstack coe cluster template delete $ctname | grep 'HTTP 404')" ]]; do sleep 10; done &
    fi
done
openstack coe cluster template list
openstack coe cluster list
