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
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="grub2 extlinux gpt"

RDEPEND="
	>=dev-lang/python-3.3
	grub2? ( >=sys-boot/grub-2.00_p5107-r2 )
	extlinux? ( >=sys-boot/syslinux-5.00 )
	gpt? ( sys-apps/gptfdisk )"

src_install() {
	# Copy the main executable
	exeinto "/opt/${PN}"
	doexe "${PN}"

	# Copy the libraries required by this executable
	cp -r "${S}/libs" "${D}/opt/${PN}"

	# Copy documentation files
	dodoc CHANGES README USAGE

	# Install default configuration file
	local config="/etc/${PN}"

	keepdir "${config}"
	insinto "${config}"
	doins "${S}/defaults/config.py"

	# Make a symbolic link: /sbin/bliss-boot
	dosym "/opt/${PN}/${PN}" "/sbin/${PN}"
}
