# Copyright 2014-2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm

DESCRIPTION="The free office suite the community has been dreaming of."
HOMEPAGE="http://libreoffice.org/"
SRC_URI="
	amd64? ( http://download.documentfoundation.org/libreoffice/stable/${PV}/rpm/x86_64/LibreOffice_${PV}_Linux_x86-64_rpm.tar.gz )"

RESTRICT="mirror strip"
LICENSE="|| ( LGPL-3+ MPL-2.0 )"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_install()
{
	local RPMSDIR=$(ls -d LibreOffice_${PV}.*)"/RPMS"
	
	if [[ ! -e ${RPMSDIR} ]]; then
		die "The LibreOffice RPMS directory was not found."
	fi

	cd "${RPMSDIR}"

	# Extract all the RPMS and move their contents to our IMAGE
	for rpm in $(ls); do
		local filesdir="${rpm%.rpm}"
		rpmunpack "${rpm}"

		cp -rf "${filesdir}"/* "${D}"	
	done
}
