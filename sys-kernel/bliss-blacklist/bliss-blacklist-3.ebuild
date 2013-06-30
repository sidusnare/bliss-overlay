# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# Other Variables
_CONF="bliss.conf"

# Main
DESCRIPTION="Blacklist file(s) that bliss-kernel(s) will use to enhance stability."
HOMEPAGE="http://funtoo.org/"
SRC_URI=""

RESTRICT="fetch"
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
	insinto /etc/modprobe.d/
	doins ${FILESDIR}/${_CONF}
}
