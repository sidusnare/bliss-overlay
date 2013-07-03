# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils mount-boot

# Variables
_LV="FB.01"				# Local Version
_R="${RANDOM}"			# Random Number for Backup
_B="/boot"				# Boot Directory

# Kernel
_BK="${_B}/vmlinuz-${PV}-${_LV}"

# Kernel Config
_BC="${_B}/config-${PV}-${_LV}"

# Kernel System.map
_BS="${_B}/System.map-${PV}-${_LV}"

# Main
DESCRIPTION="Precompiled Vanilla Kernel"
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/${PN}/${PV}-${_LV}/kernel-${PV}-${_LV}.tar.bz2"

RESTRICT="mirror strip"
LICENSE="GPL-2"
SLOT="${PV}-${_LV}-${PR}"
KEYWORDS=""

DEPEND="=sys-kernel/bliss-headers-${PVR}"
RDEPEND="=sys-kernel/bliss-modules-${PVR}
		 sys-kernel/bliss-blacklist"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	dodir /boot && insinto /boot
	doins ${S}/kernel/vmlinuz-${PV}-${_LV}
	doins ${S}/kernel/config-${PV}-${_LV}
	doins ${S}/kernel/System.map-${PV}-${_LV}
}

pkg_prerm()
{
	# Backup Kernel
	if [ -f "${_BK}" ]; then
		mv ${_BK} ${_BK}.${_R}
	fi

	# Backup Kernel Config
	if [ -f "${_BC}" ]; then
		mv ${_BC} ${_BC}.${_R}
	fi

	# Backup Kernel System.map
	if [ -f "${_BS}" ]; then
		mv ${_BS} ${_BS}.${_R}
	fi
}

pkg_postrm()
{
	# Restore Kernel
	if [ ! -f "${_BK}" ]; then
		mv ${_BK}.${_R} ${_BK}
	fi

	# Restore Kernel Config
	if [ ! -f "${_BC}" ]; then
		mv ${_BC}.${_R} ${_BC}
	fi

	# Restore Kernel System.map
	if [ ! -f "${_BS}" ]; then
		mv ${_BS}.${_R} ${_BS}
	fi
}
