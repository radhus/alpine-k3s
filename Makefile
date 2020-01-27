.PHONY: all docker genkeys build shell

APORTS_BRANCH = 3.11-stable
DOCKER_IMAGE = radhus/alpine-k3s-image-builder
DOCKER_TAG = latest

TMPDIRS = out/image out/packages out/tmp out/tmp/distfiles keys

$(TMPDIRS):
	mkdir -p $@

DOCKER_RUN = docker run --rm \
	-e PACKAGER="$(EMAIL)" \
	-v $(PWD)/aports:/home/builder/aports:ro \
	-v $(PWD)/keys:/home/builder/.abuild \
	-v $(PWD)/out/packages:/home/builder/packages \
	-v $(PWD)/out/tmp/distfiles:/var/cache/distfiles \
	-v $(PWD)/out:/home/builder/out \
	-v $(PWD)/repo:/home/builder/repo \
	--tmpfs /tmp \
	"$(DOCKER_IMAGE):$(DOCKER_TAG)"

all:
	cat Makefile
	false

aports:
	git clone \
	    --depth 1 \
	    --branch "$(APORTS_BRANCH)" \
	    https://github.com/alpinelinux/aports

docker:
	docker build -t "$(DOCKER_IMAGE):$(DOCKER_TAG)" .

shell: $(TMPDIRS)
	$(DOCKER_RUN) /bin/ash

genkeys: docker $(TMPDIRS)
	[ "$(EMAIL)" != "" ] || (echo "Set EMAIL variable" && false)
	$(DOCKER_RUN) abuild-keygen -a -i

build: docker aports $(TMPDIRS)
	$(DOCKER_RUN) /home/builder/build.sh
