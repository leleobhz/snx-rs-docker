# [snx-rs](https://github.com/ancwrd1/snx-rs) within container

## Overview

This container is intended to run 

## Images availables

All images are available at https://quay.io/repository/pqatsi/snx-rs?tab=tags and we provide the following archs:

* amd64
* arm64
* armv6 (This version is specially built for RaspberryPi 1)

## Usage

TL;DR: 

```bash
podman run --replace --rm --privileged --device=/dev/net/tun --volume=/opt/snx/sessions:/var/cache/snx-rs/sessions --cap-add=NET_ADMIN,SYS_ADMIN --network=host --name snx-rs-vpn -v /lib/modules:/lib/modules:ro quay.io/pqatsi/snx-rs:latest /usr/bin/snx-rs --mode standalone --login-type vpn --tunnel-type ipsec --ike-persist true --default-route false --no-dns true --if-name <DESIRED_IF_NAME_OUTSIDE_POD> --server-name <YOUR_VPN_HOST_HERE> --user-name <YOUR_USER_HERE> --password <YOUR_PASS_HERE> --log-level debug --client-mode endpoint_security
```

These images are tested on following environments:

* amd64 with podman
* armv6 with [OpenWRT 24.10](https://openwrt.org/releases/24.10/start) (Podman does not work nicely with previous version) on Raspberry Pi 1

## Performance

Should be same from using without container. For reference, the Raspberry Pi 1 can reach sometimes near 20mbps using IPSec.

## TODO

* CI with Github
* Upstream PR (I need some time to prepare a cleaner solution).

## License

Licensed - same way as snx-rs upstream - under the [GNU Affero General Public License version 3](https://opensource.org/license/agpl-v3/).
