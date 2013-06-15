# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-isomaker"
GITHUB_TAG="${PV}"

DESCRIPTION="Automates the recreation of the System Rescue CD ISO with ZFS SRMs included"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="amd64"
IUSE="+iso"

RDEPEND="iso? ( dev-libs/libisoburn )"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/${GITHUB_REPO}-${PV} ${S}
}

src_install() {
	mkdir -p ${D}/opt/${PN} && cd ${D}/opt/${PN}

	cp -a ${S}/* .
}

pkg_postinst() {
	elog "1. Download the System Rescue CD and place it inside the /opt/${PN}/iso directory."
	elog "2. Create or download your SRMs and place them inside the /opt/${PN}/srm directory."
	elog "3. Then run the ./create script and enjoy."
	elog ""
	elog "You can download System Rescue CD ISOs at http://www.sysresccd.org/Sysresccd-versions"
}
