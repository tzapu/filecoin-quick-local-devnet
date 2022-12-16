SHELL=/usr/bin/env bash

print-%:
	@echo $*=$($*)

## DOCKER IMAGES
docker_user?=filecoin
lotus_branch?=
lotus_version?=dev
lotus_src_dir?=
ffi_from_source?=1
ifeq ($(lotus_src_dir),)
    lotus_src_dir=/tmp/lotus-$(lotus_version)
    lotus_checkout_dir=$(lotus_src_dir)
else
    lotus_version=dev
    lotus_checkout_dir=
endif
lotus_test_image=$(docker_user)/lotus-test:$(lotus_version)
docker_build_cmd=docker build --build-arg LOTUS_TEST_IMAGE=$(lotus_test_image) \
	--build-arg FFI_BUILD_FROM_SOURCE=$(ffi_from_source) $(docker_args)

### lotus test docker image
info/lotus-test:
	@echo Lotus dir = $(lotus_src_dir)
	@echo Lotus ver = $(lotus_version)
.PHONY: info/lotus-test
$(lotus_checkout_dir):
	git clone --depth 1 --branch $(lotus_branch) https://github.com/filecoin-project/lotus $@
docker/lotus-test: info/lotus-test | $(lotus_checkout_dir)
	cd $(lotus_src_dir) && $(docker_build_cmd) -f Dockerfile.lotus --target lotus-test \
		-t $(lotus_test_image) .
.PHONY: docker/lotus-test

### devnet images
docker/%:
	cd docker/devnet/$* && $(docker_build_cmd) -t $(docker_user)/$*-dev:$(lotus_version) \
		--build-arg BUILD_VERSION=$(lotus_version) .
docker/all: docker/lotus-test docker/lotus docker/lotus-miner
.PHONY: docker/all
