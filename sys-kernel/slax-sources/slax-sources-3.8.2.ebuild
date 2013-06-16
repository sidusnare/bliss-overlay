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

DESCRIPTION="Kernel Sources and Patches for the Slax 7.0.8 x86_64"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/${KERNEL_FILE}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="amd64"

S="${WORKDIR}/${KERNEL}"

src_unpack()
{
	unpack ${KERNEL_FILE}
	mv ${KERNEL_FILE%.tar*} ${KERNEL}
}

src_prepare()
{
	epatch "${FILESDIR}/${PV}/${KERNEL_PATCH}" || die "Failed to apply ${PV} patch"
	epatch "${FILESDIR}/${PV}/aufs/aufs3-kbuild.patch" || die "Failed to apply aufs3-kbuild.patch"
	epatch "${FILESDIR}/${PV}/aufs/aufs3-base.patch" || die "Failed to apply aufs3-base.patch"
	epatch "${FILESDIR}/${PV}/aufs/aufs3-proc_map.patch" || die "Failed to apply aufs3-proc_map.patch"
}

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	mkdir -p ${D}/usr/src
	mv ${S} ${D}/usr/src
	cd ${D}/usr/src/${KERNEL} && make distclean

	einfo "Copying Documentation and FS"
	cp -rv ${FILESDIR}/${PV}/aufs/Documentation .
	cp -rv ${FILESDIR}/${PV}/aufs/fs .
	einfo "Copying AUFS_TYPE"
	cp ${FILESDIR}/${PV}/aufs/include/uapi/linux/aufs_type.h include/linux/
	einfo "Copying kernel config"
	cp ${FILESDIR}/${PV}/${KERNEL_CONF} .config

	# Change local version
	#sed -i -e "s%CONFIG_LOCALVERSION=\"\"%CONFIG_LOCALVERSION=\"-${TAIL}\"%" .config

	# Remove old initramfs path crap
	#sed -i -e "s%CONFIG_INITRAMFS_SOURCE=\"/var/tmp/genkernel/initramfs-${PV}-${TAIL}.cpio\"%CONFIG_INITRAMFS_SOURCE=\"\"%" .config

	# Set CONFIG_USER_NS (User Namespaces) to no
	#sed -i -e "s%CONFIG_USER_NS=y%CONFIG_USER_NS=n%" .config
}

