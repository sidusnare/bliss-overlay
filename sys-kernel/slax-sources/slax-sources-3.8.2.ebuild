# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# For Slax CD 7.0.8 x86_64
TAIL="SLAX"
KERNEL="linux-${PV}-${TAIL}"
KERNEL_CONF="config-${PV}"
KERNEL_FILE="linux-3.8.tar.bz2"
KERNEL_PATCH="patch-${PV}.xz"
AD="aufs3-standalone.git"				# AUFS Directory
AT="origin/aufs3.8"						# AUFS Target

DESCRIPTION="Kernel Sources and Patches for the Slax 7.0.8 x86_64"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/${KERNEL_FILE}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="amd64"

DEPEND="dev-vcs/git"

S="${WORKDIR}/${KERNEL}"

src_unpack()
{
	unpack ${KERNEL_FILE}
	mv ${KERNEL_FILE%.tar*} ${KERNEL}

	# Get latest AUFS for this kernel
	git clone git://git.code.sf.net/p/aufs/aufs3-standalone ${AD}
	cd ${AD} && git checkout -b funtoo ${AT}
}

src_prepare()
{
	epatch "${FILESDIR}/${PV}/${KERNEL_PATCH}" || die "Failed to apply ${PV} patch"
	epatch "${WORKDIR}/${AD}/aufs3-kbuild.patch" || die "Failed to apply aufs3-kbuild.patch"
	epatch "${WORKDIR}/${AD}/aufs3-base.patch" || die "Failed to apply aufs3-base.patch"
	epatch "${WORKDIR}/${AD}/aufs3-proc_map.patch" || die "Failed to apply aufs3-proc_map.patch"
}

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	dodir /usr/src
	cp -r ${S} ${D}/usr/src

	cd ${D}/usr/src/${KERNEL}

	# Copying Documentation and FS
	cp -r ${WORKDIR}/${AD}/Documentation .
	cp -r ${WORKDIR}/${AD}/fs .

	# Copying AUFS_TYPE
	cp ${WORKDIR}/${AD}/include/uapi/linux/aufs_type.h include/linux/

	# Copying kernel config
	cp ${FILESDIR}/${PV}/${KERNEL_CONF} .config
}
