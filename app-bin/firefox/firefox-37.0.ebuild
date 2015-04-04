# Copyright 2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

_FN="${PN}-${PV}"

DESCRIPTION="An open source web browser"
HOMEPAGE="https://www.mozilla.org/en-US/firefox/"
SRC_URI="
    amd64? ( https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${PV}/linux-x86_64/en-US/${_FN}.tar.bz2 )"

RESTRICT="mirror strip"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}"

src_install()
{
    local FINALDIR="${D}/opt/${PN}"
	local USR_BIN="${D}/usr/bin"
	local APP_ICON_DIR="${D}/usr/share/applications"
	local MOZILLA_FIVE_HOME="/opt/${PN}"

    mkdir -p "${FINALDIR}" "${USR_BIN}" "${APP_ICON_DIR}"

	# Copy files
    cp -r "${S}"/* "${FINALDIR}"

    # Make symlink to firefox binary
    cd "${USR_BIN}"
    ln -s "${FINALDIR}/${PN}" ${PN}

	# Share plugins directory
	local PLUGIN_BASE_PATH="/usr/$(get_libdir)" 
	dosym "${PLUGIN_BASE_PATH}/nsbrowser/plugins" "${MOZILLA_FIVE_HOME}/browser/plugins"

	# Copy icon
	cp "${FILESDIR}/${PN}.desktop" "${APP_ICON_DIR}"
}

pkg_postinst()
{
	elog "Since this is a precompiled binary that is installed in /opt, you will by default"
	elog "receive \"Update\" messages that will not work (no permission to do so)."
	elog "In order to disable these update messages, disable automatic updating/checking in Firefox."
	elog "To do so, open up Firefox and go to Preferences -> Advanced -> Update, and check the"
	elog "\"Never check for updates\" option."
}
