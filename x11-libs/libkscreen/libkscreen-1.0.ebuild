# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Library for KScreen: Improved screen management for KDE"
HOMEPAGE="http://kde.org/"
SRC_URI="http://download.kde.org/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/cmake"
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
