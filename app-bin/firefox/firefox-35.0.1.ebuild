# Copyright 2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

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

    mkdir -p "${FINALDIR}" "${USR_BIN}" "${APP_ICON_DIR}"

	# Copy files
    cp -r "${S}"/* "${FINALDIR}"

    # Make symlink to firefox binary
    cd "${USR_BIN}"
    ln -s "${FINALDIR}/${PN}" ${PN}

	# Copy icon
	cp "${FILESDIR}/${PN}.desktop" "${APP_ICON_DIR}"
}
