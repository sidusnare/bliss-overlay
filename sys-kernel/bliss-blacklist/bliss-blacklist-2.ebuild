# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# Other Variables
_REAL="/etc/modprobe.d"
_TMP="${_REAL}/saved"

# Main
DESCRIPTION="Blacklist files that bliss-kernel(s) will use to enhance stability."
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/bliss-kernel/${P}.tar.bz2"

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
	mkdir -p ${D}/etc/modprobe.d/
	cp -r ${S}/blacklist/* ${D}/etc/modprobe.d/
}

pkg_preinst()
{
	# Backup the old blacklist files
	if [ ! -d "${_TMP}" ]; then
		mkdir ${_TMP}

		if [ ! -d "${_TMP}" ]; then
			die "Could not create ${_TMP} directory"
		fi

		mv ${_REAL}/*.conf ${_TMP}
	fi
}

pkg_postrm()
{
	# Restore the original file since we no longer have the bliss-kernel files.
	if [ -d "${_TMP}" ]; then
		mv ${_TMP}/*.conf ${_REAL}
		rmdir ${_TMP}

		if [ -d "${_TMP}" ]; then
			die "Could not remove ${_TMP} directory"
		fi
	fi
}
