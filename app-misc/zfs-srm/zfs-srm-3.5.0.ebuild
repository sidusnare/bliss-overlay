# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

DESCRIPTION="Prebuilt ZFS System Rescue Module for System Rescue CD"
HOMEPAGE="http://ftp.osuosl.org/pub/funtoo/distfiles/sysrescuecd"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/sysrescuecd/zfs-3.4.37-std350-amd64_0.6.1.tar.xz"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64"
IUSE="iso"

RDEPEND="iso? ( dev-libs/libisoburn )"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/isomaker ${WORKDIR}/${P}
}

src_install() {
	mkdir -p ${D}/opt/${P} && cd ${D}/opt/${P}

	cp -a ${S}/* .
}

pkg_postinst() {
	elog "Download the System Rescue CD ${PV} and place it inside the"
	elog "/opt/${P}/iso directory. Then run the make_iso.sh if you want"
	elog "to make an iso, or run the usb_inst.sh if you want to make a" 
	elog "bootable usb."
	elog ""
	elog "You can download the System Rescue CD ${PV} iso at"
	elog "http://ftp.osuosl.org/pub/funtoo/distfiles/sysrescuecd/systemrescuecd-x86-${PV}.iso"
}
