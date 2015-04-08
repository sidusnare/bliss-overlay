# Copyright 2013-2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-initramfs"
GITHUB_TAG="${PV}"

DESCRIPTION="Allows you to boot your system's rootfs installed on ZFS (or filesystems in the kernel. Ex: btrfs)"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror strip"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="zfs luks +udev"

RDEPEND="
    >=dev-lang/python-3.3
    app-arch/cpio
    udev? ( virtual/udev )
    zfs? ( sys-kernel/spl
           sys-fs/zfs
           sys-fs/zfs-kmod )

    luks? ( sys-fs/cryptsetup
            app-crypt/gnupg )"

S="${WORKDIR}/${GITHUB_REPO}-${GITHUB_TAG}"

src_install() {
    # Copy the main executable
    local executable="mkinitrd.py"
    exeinto "/opt/${PN}"
    doexe "${executable}"

    # Copy the libraries required by this executable
    cp -r "${S}/files" "${D}/opt/${PN}"
    cp -r "${S}/pkg" "${D}/opt/${PN}"

    # If udev is explictly disabled, disable it in the Udev hook
    if ! use udev; then
        local useUdevLine=20
        sed -i -e "${useUdevLine}"s/1/0/ "${D}/opt/${PN}/pkg/hooks/Udev.py"
    fi

    # Copy documentation files
    dodoc CHANGES README USAGE

    # Make a symbolic link: /sbin/bliss-initramfs
    dosym "/opt/${PN}/${executable}" "/sbin/${PN}"
}

pkg_postinst()
{
    if ! use udev; then
        ewarn "${PN} has been installed without udev support."
        ewarn "You will not be able to boot your machine using UUIDs."
    fi
}
