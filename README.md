Upload images:

	./upload-fedora-atomic.sh
	./upload-fedora-coreos.sh

Create cluster:

	./fedora-atomic.sh
	./fedora-coreos.sh

Install and run sonobuoy:

        ./install-sonobuoy.sh
	./sonobuoy-atomic.sh
	./sonobuoy-coreos.sh

Destroy cluster:

	action=destory ./fedora-atomic.sh
	action=destory ./fedora-coreos.sh
