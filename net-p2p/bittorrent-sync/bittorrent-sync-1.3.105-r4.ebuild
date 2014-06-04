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

	# Path to 'btsync' executable
	local btsexe="/opt/${NAME}/${NAME}"

	# Set the daemon's group to 'btsync'
	chown root:btsync "${btsexe}"

	# Set guid so that files created under this process are created as the group
	chmod 2775 "${btsexe}"

	# Fixed home directory group permissions since it's currently btsync:root
	chown :btsync /home/btsync

	# Fixed permissions since umask hasn't taken affect
	chmod 2775 /home/btsync

	# Create the .sync directory where sync metadata will be stored
	mkdir /home/btsync/.sync

	# Fix .sync directory ownership and permissions
	chown btsync /home/btsync/.sync
	chmod 2775 /home/btsync/.sync

	elog "In order for shared files between groups to be as easy as possible,"
	elog "please switch your system umask from 022 to 002. This can be done by"
	elog "modifying /etc/profile. The following command will do this for you:"
	elog ""
	elog "sed -i 's/umask 022/umask 002/' /etc/profile"
	elog ""
	elog "Then run . /etc/profile so that your new umask takes affect."
	elog ""
	elog "After this is done, you can add any users that need to modify files in"
	elog "/home/btsync to your btsync group. To add your user to the btsync group,"
	elog "do the following:"
	elog ""
	elog "gpasswd -a <your user> btsync"
	elog ""
	elog "You will also need to configure btsync by editing /etc/btsync/config"
	elog ""
	elog "After checking your config, start the service and point your browser to"
	elog "http://localhost:8888 , the default username and password is admin/admin."
}

pkg_postrm() {
	elog "If you no longer need to have your system's umask set to 002,"
	elog "Consider switching it back to the Gentoo default of 022 in /etc/profile"
}
