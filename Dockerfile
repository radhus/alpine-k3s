FROM alpine:3.11

RUN apk add --no-cache \
    abuild \
    alpine-conf \
    alpine-sdk \
    apk-tools \
    atools \
    build-base \
    busybox \
    fakeroot \
    git \
    grub-efi \
    mtools \
    squashfs-tools \
    sudo \
    syslinux \
    && adduser -s /bin/ash -D builder \
    && echo "builder ALL=NOPASSWD: ALL" >> /etc/sudoers.d/builder \
    && addgroup builder abuild \
    && mkdir -p /var/cache/distfiles \
    && chmod a+w /var/cache/distfiles

USER builder
WORKDIR /home/builder
ENV HOME /home/builder

COPY mkimg.k3s.sh ./
COPY build.sh ./
