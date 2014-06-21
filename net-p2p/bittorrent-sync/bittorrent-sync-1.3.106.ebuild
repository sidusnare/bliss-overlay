# Copyright 2013-2014 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user systemd

NAME="btsync"
DESCRIPTION="Fast, unlimited and secure file-syncing. Free from the cloud."
HOMEPAGE="http://labs.bittorrent.com/experiments/sync.html"
SRC_URI="
	amd64?	( http://syncapp.bittorrent.com/${PV}/btsync_x64-${PV}.tar.gz )
	x86?	( http://syncapp.bittorrent.com/${PV}/btsync_i386-${PV}.tar.gz )
	arm?	( http://syncapp.bittorrent.com/${PV}/btsync_arm-${PV}.tar.gz )
	ppc?	( http://syncapp.bittorrent.com/${PV}/btsync_powerpc-${PV}.tar.gz )"

RESTRICT="mirror strip"
LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="opt/btsync/btsync"

S="${WORKDIR}"

src_install() {
	# Install the executable
	exeinto "/opt/${NAME}"
	doexe "${S}/${NAME}"

	# Install a default configuration file
	insinto "/etc/${NAME}"
	doins "${FILESDIR}/config"

	# Install the OpenRC init file
	doinitd "${FILESDIR}/init.d/${NAME}"

	# Install the systemd unit file
	systemd_dounit "${FILESDIR}/systemd/${NAME}.service"
}

pkg_postinst() {
	# Let's set up the user and group for this daemon so that members of the group
	# can have write permissions.
	enewgroup btsync
	enewuser btsync -1 /bin/bash /home/btsync "btsync"

	# Create the .sync directory where sync metadata will be stored
	mkdir /home/btsync/.sync

	# Fixed home directory group permissions since it's currently btsync:root
	chown btsync:btsync /home/btsync

	# Fix .sync directory ownership
	chown btsync:btsync /home/btsync/.sync

	elog "In order for shared files between local users to be as easy as possible,"
	elog "please set up ACLs on your system."
	elog ""
	elog "You will also need to configure btsync by editing /etc/btsync/config"
	elog ""
	elog "After checking your config, start the service and point your browser to"
	elog "http://localhost:8888 , the default username and password is admin/admin."
}
