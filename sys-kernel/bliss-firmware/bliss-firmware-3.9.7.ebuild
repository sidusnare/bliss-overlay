# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

REV="FB.01"

DESCRIPTION="The firmware files for bliss-kernel."
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/bliss-kernel/${PV}-${REV}/firmware-${PV}-${REV}.tar.bz2"

RESTRICT="mirror strip"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	mkdir -p ${D}/lib/firmware
	cp -r ${S}/firmware/* ${D}/lib/firmware
}
