set -x

kube_tag=${kube_tag:-v1.16.0}
nodes=${nodes:-2}
for nd in flannel calico; do
    name=k8s-$nd-$os_distro
    ctname=$name-$kube_tag
    if [ "$action" != "destroy" ]; then
        if [[ -z $(openstack coe cluster template list | grep $ctname) ]]; then
            image=${image:-`openstack image list --property os_distro=$os_distro -f value -c Name`}
            openstack coe cluster template create --floating-ip-enabled --external-network public --fixed-network private --fixed-subnet private-subnet --image $image --flavor ds2G --master-flavor ds2G --docker-storage-driver overlay2 --coe kubernetes --network-driver $nd --labels kube_tag=$kube_tag --dns-nameserver 1.1.1.1 $ctname
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
        sonobuoy run --e2e-focus "should provide DNS for services" # minimal test
    elif [ "$action" == "destroy" ]; then
        openstack coe cluster delete $name
        while [[ -z "$(openstack coe cluster template delete $ctname | grep 'HTTP 404')" ]]; do sleep 10; done &
    fi
done
openstack coe cluster template list
openstack coe cluster list
