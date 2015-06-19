# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lsyncd/lsyncd-2.1.5.ebuild,v 1.3 2013/12/24 12:42:40 ago Exp $

EAPI=5

DESCRIPTION="Live Syncing (Mirror) Daemon"
HOMEPAGE="http://code.google.com/p/lsyncd/"
SRC_URI="http://lsyncd.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~arm-linux ~x86-linux"

CDEPEND=">=dev-lang/lua-5.1[deprecated]"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	net-misc/rsync"

src_install() {
	# Install main binary
	insinto /usr/bin
	dobin "${PN}"

	# Make log directory
	dodir "/var/log/${PN}"

	# Install OpenRC scripts
	doinitd "${FILESDIR}/init.d/${PN}"
	doconfd "${FILESDIR}/conf.d/${PN}"

	# Install default/sample config
	insinto "/etc/${PN}"
	doins "${FILESDIR}/${PN}/${PN}.conf"

	# Install doc/man files
	dodoc examples/* ChangeLog
	doman doc/*.1
}
