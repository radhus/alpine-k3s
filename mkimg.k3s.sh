profile_k3s() {
    title="k3s"
    profile_base
    profile_abbrev="k3s"
    arch="x86_64"
    image_ext="tar.gz"
    output_format="targz"
    initfs_cmdline="modules=loop,squashfs,sd-mod,usb-storage"
    kernel_cmdline="console=tty0 console=hvc0 nomodeset cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
    kernel_flavors="virt"
    kernel_addons="wireguard"
    apks="alpine-base alpine-mirrors busybox chrony e2fsprogs iptables openssl openssh tzdata"
}
