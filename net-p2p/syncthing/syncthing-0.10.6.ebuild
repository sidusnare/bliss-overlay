# Copyright 2014 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user

GITHUB_USER="syncthing"
GITHUB_REPO="syncthing"
GITHUB_TAG="${PV}"

NAME="syncthing"
DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"

SRC_URI="
	amd64? ( https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/v${GITHUB_TAG}.tar.gz -> ${P}.tar.gz )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-lang/go-1.3.0
	dev-vcs/git
	dev-vcs/mercurial"

S="${WORKDIR}"

configDir="/etc/${PN}"
config="${configDir}/config.xml"
syncPath="/root/Sync"

src_install() {
	# Create directory structure recommended by SyncThing Documentation
	# Since Go is "very particular" about file locations.
	local newBaseDir="src/github.com/${PN}"
	local newWorkDir="${newBaseDir}/${PN}"

	mkdir -p "${newBaseDir}"
	mv "${P}" "${newWorkDir}"

	cd "${newWorkDir}"

	# Build SyncThing ;D
	go run build.go

	# Copy compiled binary over to image directory
	dobin "bin/${PN}"

	# Install the OpenRC init file
	doinitd "${FILESDIR}/init.d/${NAME}"
}

pkg_postinst() {
	if [[ ! -d "${configDir}" ]]; then
		mkdir "${configDir}"
	fi

	if [[ ! -e "${config}" ]]; then
		einfo "Generating default configuration file ..."

		syncthing -generate "${configDir}"

		# Replace incorrect configuration path
		local incorrectPath="$(grep path= ${config} | awk '{ print $3 }')"
		sed -i s:${incorrectPath}:path=\"${syncPath}\": ${config}
	fi

	elog "In order to be able to view the Web UI remotely, edit your ${config}"
	elog "and change the 127.0.0.1:8080 to 0.0.0.0:8080 in the 'address' section."
	elog ""
	elog "For a default generated config, the default sync directory is /root/Sync."
	elog "You can change these either by editing the ${config}, or by clicking the"
	elog "'Edit' button in the Web UI."
	elog ""
	elog "After checking your config, start the service and point your browser to http://localhost:8080/"
	elog ""
	elog "NOTE: If you update or shutdown the app ${PN} through the Web UI, when it restarts,"
	elog "OpenRC will _not_ know its new PID number. You can still update through the Web UI,"
	elog "just be aware of this since the OpenRC start/stop will complain. You could of course"
	elog "stop the server via the Web UI after the upgrade and stop/start it again via OpenRC"
	elog "to have it in sync again."
	elog ""
	elog "Run 'rc-config start ${PN}' to start the application."
}
