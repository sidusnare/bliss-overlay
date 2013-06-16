# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

GITHUB_USER="fearedbliss"
GITHUB_REPO="Bliss-Initramfs-Creator"
GITHUB_TAG="${PV}"

DESCRIPTION="Creates an initramfs for ZFS"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="srm luks"

RDEPEND="
	app-arch/cpio
	sys-apps/busybox
	sys-kernel/spl
	sys-fs/zfs
	sys-fs/zfs-kmod
	srm? ( sys-fs/squashfs-tools )
	luks? ( sys-fs/cryptsetup )"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/${GITHUB_REPO}-${PV} ${WORKDIR}/${P}
}

src_install() {
	mkdir -p ${D}/opt/${PN} && cd ${D}/opt/${PN}

	cp -a ${S}/* .
}
