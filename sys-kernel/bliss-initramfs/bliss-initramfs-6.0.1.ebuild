# Copyright 2013-2014 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-initramfs"
GITHUB_TAG="${PV}"

DESCRIPTION="Allows you to boot your system's root filesystem installed on ZFS (also supports btrfs)"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror strip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="zfs luks"

RDEPEND="
	>=dev-lang/python-3.3
	app-arch/cpio
	virtual/udev
	zfs? ( sys-kernel/spl
		   sys-fs/zfs
	       sys-fs/zfs-kmod )

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

	# Make a symbolic link: /sbin/bliss-initramfs
	dosym "/opt/${PN}/mkinitrd" "/sbin/${PN}"
}
