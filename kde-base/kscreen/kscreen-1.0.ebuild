# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

DESCRIPTION="Improved screen management for KDE"
HOMEPAGE="http://kde.org/"
SRC_URI="http://download.kde.org/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-util/cmake
	=x11-libs/libkscreen-${PV}"

RDEPEND="${DEPEND}"

src_compile()
{
	cmake \
	 	-DCMAKE_INSTALL_PREFIX:PATH=/usr ${S} || die "Could not configure ${PN} with cmake."
	emake
}

src_install()
{
	emake DESTDIR="${D}" install
}

pkg_postinst()
{
	elog "Run the following commands to disable the old screen module and enable KScreen."
	elog ""
	elog "qdbus org.kde.kded /kded org.kde.kded.unloadModule randrmonitor"
	elog "qdbus org.kde.kded /kded org.kde.kded.setModuleAutoloading randrmonitor false"
	elog "qdbus org.kde.kded /kded org.kde.kded.loadModule kscreen"
}
