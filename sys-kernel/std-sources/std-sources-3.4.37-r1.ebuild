# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# For System Rescue CD 3.5.0 (Standard Kernel)
TAIL="std350-amd64"
KERNEL="linux-${PV}-${TAIL}"
KERNEL_CONF="kernel-${PV}-${TAIL}.conf"
KERNEL_FILE="linux-3.4.tar.bz2"

DESCRIPTION="Kernel Sources and Patches for the System Rescue CD Standard Kernel"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/${KERNEL_FILE}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64"

S="${WORKDIR}/${KERNEL}"

src_unpack()
{
	unpack ${KERNEL_FILE}
	mv ${KERNEL_FILE%.tar*} ${KERNEL}
}

src_prepare()
{
	epatch ${FILESDIR}/${PV}/${PN}-3.4-01-stable-${PV}.patch.bz2 || die "std-sources stable patch failed."
	epatch ${FILESDIR}/${PV}/${PN}-3.4-02-fc16.patch.bz2 || die "std-sources fedora patch failed."
	epatch ${FILESDIR}/${PV}/${PN}-3.4-03-aufs.patch.bz2 || die "std-sources aufs patch failed."
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
	cp ${FILESDIR}/${PV}/${KERNEL_CONF} .config
	sed -i -e "s%CONFIG_LOCALVERSION=\"\"%CONFIG_LOCALVERSION=\"-${TAIL}\"%" .config
	sed -i -e "s%CONFIG_INITRAMFS_SOURCE=\"/var/tmp/genkernel/initramfs-${PV}-${TAIL}.cpio\"%CONFIG_INITRAMFS_SOURCE=\"\"%" .config
}

