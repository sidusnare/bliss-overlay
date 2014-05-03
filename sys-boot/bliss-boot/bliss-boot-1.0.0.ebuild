# Copyright 2014 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-boot"
GITHUB_TAG="${PV}"

DESCRIPTION="Bootloader Configuration and Installation Utility"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror strip"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="grub2 extlinux gpt"

RDEPEND="
	>=dev-lang/python-3.3
	grub2? ( >=sys-boot/grub-2.00_p5107-r2 )
	extlinux? ( sys-boot/syslinux )
	gpt? ( sys-apps/gptfdisk )"

src_install() {
	# Copy the main files
	mkdir -p "${D}/opt/${PN}" && cd "${D}/opt/${PN}"
	cp -a "${S}"/* .

	# Make a symbolic link: /sbin/bliss-boot
	mkdir -p "${D}/sbin" && cd "${D}/sbin"
	ln -s "${D}opt/${PN}/${PN}" "${PN}"

	# Copy conf.py file to /etc/bliss-boot/conf.py
	mkdir -p "${D}/etc/${PN}"
	cp "${D}/opt/${PN}/defaults/config.py" "${D}/etc/${PN}"
}
