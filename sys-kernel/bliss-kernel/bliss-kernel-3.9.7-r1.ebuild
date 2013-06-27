# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

REV="FB.01"

DESCRIPTION="Precompiled ${PV}: Kernel + Modules"
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/${PN}/${PV}-${REV}/kernel-${PV}-${REV}.tar.bz2"

RESTRICT="mirror binchecks strip"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64"

DEPEND="=sys-kernel/bliss-headers-${PV}
		=sys-kernel/bliss-firmware-${PV}"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	mkdir ${D}/boot/
	cp -r ${S}/kernel/* ${D}/boot/

	mkdir -p ${D}/lib/modules/
	cp -r ${S}/modules/* ${D}/lib/modules/
}
