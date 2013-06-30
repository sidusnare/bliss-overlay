# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# Other Variables
_M="/lib/modules/${PV}-${LV}"
_REAL="/lib/modprobe.d"
_TMP="${_REAL}/saved"
_C="usb-load-ehci-first.conf"
_USB="${_REAL}/${_C}"
_USB_S="${_TMP}/${_C}"

# Main
DESCRIPTION="Blacklist files that bliss-kernel(s) will use to enhance stability."
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/bliss-kernel/${PN}-${PV}.tar.bz2"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	mkdir -p ${D}/lib/modprobe.d/
	cp -r ${S}/blacklist/* ${D}/lib/modprobe.d/
}

pkg_postinst()
{
	# Back up the default usb-load-ehci-first config because now we will be
	# using the usb-controller.conf which is exactly the same thing.
	if [ -f "${_USB}" ]; then
		if [ ! -d "${_TMP}" ]; then
			mkdir ${_TMP}

			if [ ! -d "${_TMP}" ]; then
				die "Could not create ${_TMP} directory"
			fi

			mv ${_USB} ${_TMP}
		fi
	fi
}
pkg_postrm()
{
	# Restore the original file since we no longer have the bliss-kernel files.
	if [ ! -f "${_USB}" ]; then
		if [ -d "${_TMP}" ]; then
			mv ${_USB_S} ${_REAL}
			rmdir ${_TMP}

			if [ -d "${_TMP}" ]; then
				die "Could not remove ${_TMP} directory"
			fi
		fi
	fi
}
