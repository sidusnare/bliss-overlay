# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# Variables
_LV="FB.01"						# Local Version
_KP="/usr/src"					# Kernel Prefix
_KN="linux-${PV}-${_LV}"		# Kernel Directory Name
_KD="${_KP}/${_KN}"				# Kernel Directory
_R="${RANDOM}"					# Random Number for Backup

DESCRIPTION="Kernel headers for bliss-kernel. Enables you to build external modules."
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/bliss-kernel/${PV}-${_LV}/headers-${PV}-${_LV}.tar.bz2"

RESTRICT="mirror strip"
LICENSE="GPL-2"
SLOT="${PV}-${_LV}-${PR}"
KEYWORDS=""

IUSE="symlink"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	dodir ${_KP}
	cp -r ${S}/headers/${_KN} ${D}/${_KP}
}

pkg_postinst()
{
	# Set the kernel symlink if symlink use is set or it doesn't exist
	if use symlink || [ ! -h "${_KP}/linux" ]; then
		eselect kernel set ${_KN}
	fi
}

pkg_prerm()
{
	# Backup kernel headers directory so that it doesn't get deleted by portage
	if [ -d "${_KD}" ] && [ ! -d "${_KD}.${_R}" ]; then
		mv ${_KD} ${_KD}.${_R}
	fi
}

pkg_postrm()
{
	# Restore kernel headers directory
	if [ ! -d "${_KD}" ] && [ -d "${_KD}.${_R}" ]; then
		mv ${_KD}.${_R} ${_KD}
	fi
}
