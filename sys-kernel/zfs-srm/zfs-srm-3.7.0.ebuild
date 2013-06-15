# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

ZOLVER="0.6.1"

DESCRIPTION="Prebuilt ZFS System Rescue Module for System Rescue CD"
HOMEPAGE="http://jonathanvasquez.com/"
SRC_URI="http://jonathanvasquez.com/files/sysresccd/${PV}/srms/zfs-srms-${PV}_amd64_${ZOLVER}.tar.bz2"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="amd64"
IUSE=""

RDEPEND="app-misc/bliss-isomaker"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/srms-${PV} ${WORKDIR}/${P}
}

src_install() {
	mkdir -p ${D}/opt/bliss-isomaker/${PV} && cd ${D}/opt/bliss-isomaker/${PV}

	cp -a ${S}/* .
}

pkg_postinst() {
	elog "The ZFS SRMs have been installed in the /opt/bliss-isomaker/${PV}"
	elog "directory. Copy the SRMs to the srm folder, copy your ISO to the iso"
	elog "folder, and then create your new ISO."
}
