# Copyright 2013-2014 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user

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
IUSE="umask"

#RDEPEND="
#	acl? ( sys-apps/acl )
#"

QA_PREBUILT="opt/btsync/btsync"

S="${WORKDIR}"

src_install() {
	# Install the executable
	exeinto "/opt/${NAME}"
	doexe "${S}/${NAME}"

	# Install a default configuration file
	dodir "/etc/${NAME}"
	./"${NAME}" --dump-sample-config > "${D}/etc/${NAME}/config"

	# Install the OpenRC init file
	doinitd "${FILESDIR}/init.d/${NAME}"
}

# Let's set up the user and group for these daemon so we don't run as root
# and also so that members of the group can have write permissions
pkg_postinst() {
	# If the user decided to use the "umask" flag, we will switch the system umask
	# from the Gentoo default of 022 to 002 which basically gives new files write access
	# to the owner and the group. This could be a security risk, but usually user files
	# are also owned only by a group under the same name as the user. Thus a user
	# would usually explictly chmod any files that they would want to share with other users.
	if use umask; then
		sed -i 's/umask 022/umask 002/' /etc/profile
		elog "The system umask has been switched from 022 to 002."
		elog ""
		elog "Please add any user that needs to modify btsync hosted files to the \"btsync\" group!"
		elog ""
		elog "Example: gpasswd -a <your user> btsync"
		elog ""
		elog "Please run . /etc/profile so that your new umask takes affect."
	fi

	enewgroup btsync
	enewuser btsync -1 /bin/bash /home/btsync "btsync"
	
	# Fixed home directory group permissions since it's currently btsync:root
	chown :btsync /home/btsync

	# Fixed permissions since umask hasn't taken affect
	chmod 775 /home/btsync

	# Path to 'btsync' executable
	local btsexe="/opt/${NAME}/${NAME}"

	# Set the daemon to run under the btsync user and change binary ownership
	chown btsync:btsync "${btsexe}"

	# Set suid so that daemon runs under btsync user rather than root
	# (when started from openrc as root)
	chmod 6775 "${btsexe}"

	# If the user decided to enable ACL support, we can set default acl options
	# to the /home/btsync directory so that any directories/files in their can be
	# shared by whatever users the user wants.
	#if use acl; then
	#	elog "ACL support activated"
	#
	#	elog "Please make sure that the filesystem that is hosting your btsync files is mounted"
	#	elog "with the 'acl' mount option. Adding the mount option so your /etc/fstab will ensure"
	#	elog "that the acl is set during boot. If you want to remount your filesystem with acl without"
	#	elog "rebooting, you can do the following: mount -o rw,acl,remount <filesystem>"
	#else
	#	elog "ACL support disabled"
	#fi

	#if ! use acl && ! use umask; then
	if ! use umask; then
		elog "The system umask was not switched to 002!"
		elog ""
		elog "You will have problems when an user other than the 'btsync' use"
		elog "tries to modify an already modified file."
	fi
}

pkg_postrm() {
	elog "You can switch the system umask from 002 to the default 022 if you desire"
	elog "checking your /etc/profile file."
}
