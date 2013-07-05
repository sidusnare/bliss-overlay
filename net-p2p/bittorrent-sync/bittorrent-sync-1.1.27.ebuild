# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

NAME="btsync"
DESCRIPTION="Automatically sync files via secure, distributed technology."
HOMEPAGE="http://labs.bittorrent.com/experiments/sync.html"
SRC_URI="
	amd64?	( http://syncapp.bittorrent.com/${PV}/btsync_x64-${PV}.tar.gz )
	x86?	( http://syncapp.bittorrent.com/${PV}/btsync_i386-${PV}.tar.gz )
	arm?	( http://syncapp.bittorrent.com/${PV}/btsync_arm-${PV}.tar.gz )
	ppc?	( http://syncapp.bittorrent.com/${PV}/btsync_powerpc-${PV}.tar.gz )"

RESTRICT="mirror strip"
LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="amd64 x86 ~arm ~ppc"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="opt/btsync/btsync"

S="${WORKDIR}"

src_install() {
	mkdir -p ${D}/opt/${NAME} && cd ${D}/opt/${NAME}
	mkdir -p ${D}/etc/{init.d,${NAME}}

	cp ${S}/btsync .
	cp ${S}/LICENSE.TXT .
	cp ${FILESDIR}/config ${D}/etc/${NAME}
	cp ${FILESDIR}/init.d/${NAME} ${D}/etc/init.d/

	# Set more secure permissions
	chmod 755 ${D}/etc/init.d/btsync
}

pkg_postinst() {
	ewarn "This version contains major protocol and feature updates, including:"
	ewarn "- versioning"
	ewarn "- significant performance and memory usage improvements"
	ewarn "- bug fixes"
	ewarn ""
	ewarn "Important:"
	ewarn "- BitTorrent Sync 1.1.27 is not compatible with versions earlier than 1.1.25"
	ewarn "- Sync folders may be re-indexed at startup"
	ewarn "- Please make sure all your folders are in sync before performing upgrade"
}
