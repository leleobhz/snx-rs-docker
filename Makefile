.PHONY: default
default: act

TAG := $(shell ./get_latest_version.sh)

ifeq ($(BUILDER_AUTH),)
        BUILDER_AUTH := $(shell ./get_container_auth.sh)
endif

build-amd64:
	podman build --build-arg="snx_rs_version=$(TAG)" --platform=linux/amd64 --tag=quay.io/pqatsi/snx-rs:$(TAG)-amd64 --file Containerfile .
	podman push quay.io/pqatsi/snx-rs:$(TAG)-amd64

build-arm64:
	podman build --build-arg="snx_rs_version=$(TAG)" --platform=linux/arm64 --tag=quay.io/pqatsi/snx-rs:$(TAG)-arm64 --file Containerfile .
	podman push quay.io/pqatsi/snx-rs:$(TAG)-arm64

build-rpi:
	podman build --build-arg="snx_rs_version=$(TAG)" --platform=linux/arm/v6 --tag=quay.io/pqatsi/snx-rs:$(TAG)-armv6 --file Containerfile.armv6 .
	podman push quay.io/pqatsi/snx-rs:$(TAG)-armv6

build-manifest: build-amd64 build-arm64 build-rpi
	podman run --rm --name snx-rs-build -v /run/user/1000/containers/auth.json:/config.json:ro docker.io/mplatform/manifest-tool --docker-cfg /config.json push --type oci from-args --platforms linux/amd64,linux/arm64,linux/arm/v6 --template quay.io/pqatsi/snx-rs:$(TAG)-ARCHVARIANT --target quay.io/pqatsi/snx-rs:$(TAG) --tags latest

build: build-amd64 build-arm64 build-rpi build-manifest

act:
	DOCKER_HOST="unix:///run/user/1000/podman/podman.sock" act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-24.04 --var-file=".vars" --secret-file=".secrets" --actor "leleobhz"
