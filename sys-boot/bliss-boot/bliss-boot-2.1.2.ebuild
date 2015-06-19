# Copyright 2014-2015 Jonathan Vasquez <jvasquez1011@gmail.com>
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
KEYWORDS="amd64"

RDEPEND="
    >=dev-lang/python-3.3"

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
