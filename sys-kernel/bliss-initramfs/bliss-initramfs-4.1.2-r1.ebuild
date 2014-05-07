# Copyright 2013-2014 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GITHUB_USER="fearedbliss"
GITHUB_REPO="Bliss-Initramfs-Creator"
GITHUB_TAG="${PV}"

DESCRIPTION="Allows you to create multiple types of initramfs"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror strip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="zfs raid lvm luks"

RDEPEND="
	>=dev-lang/python-3.3
	app-arch/cpio
	app-shells/bash
	sys-apps/kmod
	sys-apps/grep

	zfs? ( sys-kernel/spl
		   sys-fs/zfs
	       sys-fs/zfs-kmod )

	raid? ( sys-fs/mdadm )

	lvm? ( sys-fs/lvm2 )

	luks? ( sys-fs/cryptsetup
			app-crypt/gnupg )"

S="${WORKDIR}/${GITHUB_REPO}-${GITHUB_TAG}"

src_install() {
	# Copy the main executable
	exeinto "/opt/${PN}"
	doexe mkinitrd

	# Copy the libraries required by this executable
	cp -r "${S}/files" "${D}/opt/${PN}"
	cp -r "${S}/pkg" "${D}/opt/${PN}"

	# Copy documentation files
	dodoc CHANGES README USAGE

	# Make a symbolic link: /sbin/bliss-boot
	dosym "/opt/${PN}/mkinitrd" "/sbin/${PN}"
}
