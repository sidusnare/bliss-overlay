# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# Local Version
LV="FB.03"

# Other Variables
_K="/usr/src/linux-${PV}-${LV}"

DESCRIPTION="The kernel headers for bliss-kernel. Enables you to build external modules."
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/bliss-kernel/${PV}-${LV}/headers-${PV}-${LV}.tar.bz2"

RESTRICT="mirror strip"
LICENSE="GPL-2"
SLOT="${PV}-${LV}"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	dodir /usr/src/
	cp -R ${S}/headers/* ${D}/usr/src/
}

pkg_postinst()
{
	# Set the kernel symlink
	eselect kernel set linux-${PV}-${LV}
}

pkg_postrm()
{
	# Check to see if the kernel directory was removed
	if [ -d "${_K}" ]; then
		rm -rf ${_K}
	fi
}
