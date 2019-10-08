set -x

kube_tag=${kube_tag:-v1.15.4}
image=`openstack image list --property os_distro=$os_distro -f value -c Name`
nodes=${nodes:-2}
for nd in flannel calico; do
    name=k8s-$nd-$os_distro
    ctname=$name-$kube_tag
    if [ "$action" == "create" ]; then
        if [[ -z $(openstack coe cluster template list | grep $name) ]]; then
            openstack coe cluster template create --floating-ip-enabled --external-network public --fixed-network private --fixed-subnet private-subnet --image $image --flavor ds2G --master-flavor ds2G --docker-storage-driver overlay2 --coe kubernetes --network-driver $nd --labels kube_tag=$kube_tag $ctname
        fi
        if [[ -z $(openstack coe cluster list | grep COMPLETE | grep $name) ]]; then
            openstack coe cluster create --keypair `hostname` --master-count 1 --node-count $nodes --cluster-template $ctname $name
        fi
    elif [ "$action" == "destroy" ]; then
        openstack coe cluster delete $name
        openstack coe cluster template delete $ctname
    fi
done
