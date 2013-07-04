# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# Variables
_LV="FB.03"						# Local Version
_MP="/lib/modules"				# Module Prefix
_MN="${PV}-${_LV}"				# Module Directory Name
_MD="${_MP}/${_MN}"				# Modules Directory
_R="${RANDOM}"					# Random Number for Backup

# Main
DESCRIPTION="Precompiled Vanilla Modules"
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/bliss-kernel/${PV}-${_LV}/modules-${PV}-${_LV}.tar.bz2"

RESTRICT="mirror strip"
LICENSE="GPL-2"
SLOT="${PV}-${_LV}-${PR}"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	dodir ${_MP}
	cp -r ${S}/modules/${_MN} ${D}/${_MP}
}

pkg_prerm()
{
	# Backup modules directory so that it doesn't get deleted by portage
	if [ -d "${_MD}" ]; then
		mv ${_MD} ${_MD}.${_R}
	fi
}

pkg_postrm()
{
	# Restore modules directory
	if [ ! -d "${_MD}" ]; then
		mv ${_MD}.${_R} ${_MD}
	fi
}
