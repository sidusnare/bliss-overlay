# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Contributor: Jonathan Vasquez <jvasquez1011@gmail.com>

# Credits to François-Xavier Payet (foux) for making the original ebuild

EAPI=5

inherit eutils user systemd

MINOR1="1079"
MINOR2="b655370"

_APPNAME="plexmediaserver"
_USERNAME="plex"
_SHORTNAME="${_USERNAME}"

# No longer using this. Mirroring it since nightly builds go away and break the ebuild.
#URI="https://nightlies.plex.tv/directdl/plex-media-server/dist-ninja"
URI="http://xyinn.org/files/linux/${_USERNAME}"

DESCRIPTION="Plex Media Server is a free media library that is intended for use with a plex client available for OS X, iOS and Android systems."
HOMEPAGE="http://www.plex.tv/"
SRC_URI="
	amd64? ( ${URI}/plexmediaserver_${PV}.${MINOR1}-${MINOR2}_amd64.deb )"
SLOT="0"
LICENSE="PlexMediaServer"
RESTRICT="mirror strip"
KEYWORDS="-* amd64"

DEPEND="net-dns/avahi"
RDEPEND="${DEPEND}"

QA_DESKTOP_FILE="usr/share/applications/plexmediamanager.desktop"

S="${WORKDIR}"

pkg_setup() {
	enewgroup ${_USERNAME}
	enewuser ${_USERNAME} -1 /bin/bash /var/lib/${_APPNAME} ${_USERNAME} --system
}

src_install() {
	local INIT_NAME="${PN}.service"
	local INIT="${FILESDIR}/systemd/${INIT_NAME}"
	local CONFIG_VANILLA="${S}/etc/default/plexmediaserver"
	local CONFIG_PATH="${D}/etc/${_SHORTNAME}"
	local PMS_DIR="${D}/usr/sbin/"
	local LOGGING_DIR="${D}/var/log/pms"
	local DEFAULT_LIBRARY_DIR="${D}/var/lib/${_APPNAME}"
	local LICENSE_FILE="${FILESDIR}/LICENSE"
	local LICENSE_DIR="${D}/usr/portage/licenses"

	# Unpack Deb
	tar xf data.tar.gz

	# Copy main files over to image
	cp -r usr/ "${D}"

	# Move the config to the correct place
	mkdir -p "${CONFIG_PATH}"
	cp "${CONFIG_VANILLA}" "${CONFIG_PATH}/${_APPNAME}.conf"
	
	# Apply patch for start_pms to use the new config file
	cd "${PMS_DIR}"
	epatch "${FILESDIR}"/start_pms.patch
	cd "${S}"

	# Remove Debian specific files
	rm "${D}/usr/share/doc/${_APPNAME}/README.Debian"

	# Make sure the logging directory is created
	mkdir -p "${LOGGING_DIR}"
	chown "${_USERNAME}":"${_USERNAME}" "${LOGGING_DIR}"

	# Create default library folder with correct permissions
	mkdir -p "${DEFAULT_LIBRARY_DIR}"
	chown "${_USERNAME}":"${_USERNAME}" "${DEFAULT_LIBRARY_DIR}"

	# Copy license (Probably not good to write to /usr/portage/licenses/)
	mkdir -p "${LICENSE_DIR}"
	cp "${LICENSE_FILE}" "${LICENSE_DIR}/PlexMediaServer"

	# Install the OpenRC init/conf files
	doinitd "${FILESDIR}/init.d/${PN}"
	doconfd "${FILESDIR}/conf.d/${PN}"

	# Install systemd service file
	systemd_newunit "${INIT}" "${INIT_NAME}"
}

pkg_postinst() {
	einfo ""
	elog "Plex Media Server is now installed. Please check the configuration file in /etc/plex/${_SHORTNAME} to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server', you will then be able to access your library at http://<ip>:32400/web/"
	einfo ""
	ewarn "Please note, that the URL to the library management has changed from http://<ip>:32400/manage to http://<ip>:32400/web!"
	ewarn "If the new management interface forces you to log into myPlex and afterwards gives you an error that you need to be a"
	ewarn "plex-pass subscriber please delete the folder WebClient.bundle inside the Plug-Ins folder found in your library!"
}
