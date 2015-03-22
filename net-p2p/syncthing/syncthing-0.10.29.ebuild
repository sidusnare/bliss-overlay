# Copyright 2014-2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user systemd

GITHUB_USER="syncthing"
GITHUB_REPO="syncthing"
GITHUB_TAG="${PV}"

NAME="syncthing"
DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"

SRC_URI="
	amd64? ( https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/v${GITHUB_TAG}.tar.gz -> ${P}.tar.gz )"

RESTRICT="mirror"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/go-1.3.0"

S="${WORKDIR}"

configDir="~/.config/syncthing"
config="${configDir}/config.xml"

src_install() {
	# Create directory structure recommended by SyncThing Documentation
	# Since Go is "very particular" about file locations.
	local newBaseDir="src/github.com/${PN}"
	local newWorkDir="${newBaseDir}/${PN}"

	mkdir -p "${newBaseDir}"
	mv "${P}" "${newWorkDir}"

	cd "${newWorkDir}"

	# Build SyncThing ;D
	go run build.go -version v${PV} -no-upgrade=true

	# Copy compiled binary over to image directory
	dobin "bin/${PN}"

	# Install the systemd unit file
	local systemdServiceFile="etc/linux-systemd/system/${PN}@.service"
	systemd_dounit "${systemdServiceFile}"
}

pkg_postinst() {
	elog "In order to be able to view the Web UI remotely (from another machine),"
	elog "edit your ${config} and change the 127.0.0.1:8080 to 0.0.0.0:8080 in"
	elog "the 'address' section."
	elog ""
	elog "After checking your config, run 'systemctl start ${PN}@<user>' to start the application."
	elog "This will start the syncthing daemon under that user."
	elog ""
	elog "Point your browser to the address above to access the Web UI."
}
