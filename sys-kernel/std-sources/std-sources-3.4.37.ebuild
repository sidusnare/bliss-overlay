# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils

# For System Rescue CD 3.5.0
DESCRIPTION="Kernel Sources for System Rescue CD + Patches"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.bz2"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="amd64"

# TAIL is used to easily subsitute the correct CONFIG_LOCALVERSION down in
# the src_install phase.
TAIL="std350-amd64"
KERNEL="linux-${PV}-${TAIL}"
KERNEL_CONF="kernel-3.4.37-${TAIL}.conf"
S="${WORKDIR}/${KERNEL}"

src_unpack()
{
	unpack linux-3.4.tar.bz2
	mv linux-3.4 ${KERNEL}
}

src_prepare()
{
	epatch ${FILESDIR}/${PV}/std-sources-3.4-01-stable-3.4.37.patch.bz2 || die "std-sources stable patch failed."
	epatch ${FILESDIR}/${PV}/std-sources-3.4-02-fc16.patch.bz2 || die "std-sources fedora patch failed."
	epatch ${FILESDIR}/${PV}/std-sources-3.4-03-aufs.patch.bz2 || die "std-sources aufs patch failed."
}

src_compile() { return; }

src_install()
{
	mkdir -p ${D}/usr/src
	cp -R ${S} ${D}/usr/src
	cd ${D}/usr/src/${KERNEL} && make distclean
	cp ${FILESDIR}/${PV}/${KERNEL_CONF} .config
	sed -i -e "s%CONFIG_LOCALVERSION=\"\"%CONFIG_LOCALVERSION=\"-${TAIL}\"%" .config
	sed -i -e "s%CONFIG_INITRAMFS_SOURCE=\"/var/tmp/genkernel/initramfs-3.4.37-std350-amd64.cpio\"%CONFIG_INITRAMFS_SOURCE=\"\"%" .config
}

