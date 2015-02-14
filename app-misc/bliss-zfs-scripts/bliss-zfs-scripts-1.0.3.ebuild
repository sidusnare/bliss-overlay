# Copyright 2014-2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-zfs-scripts"
GITHUB_TAG="${PV}"

DESCRIPTION="ZFS Snapshot & Backup Management Scripts"
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror strip"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-lang/python-3.3"

src_install() {
	# Copy the scripts
	exeinto "/usr/local/sbin/"

	files=(
		"clean_snapshots"
		"tank_backup"
		"tank_snapshot"
		"zfs_backup"
		"zfs_snapshot"
		"check_zfs_pool"
		"zpool_scrub"
	)

	for file in ${files[*]}; do
		doexe ${file}
	done

	# Copy documentation files
	dodoc README USAGE EXAMPLE
}
