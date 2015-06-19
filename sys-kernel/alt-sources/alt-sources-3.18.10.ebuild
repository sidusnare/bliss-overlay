# Copyright 2013-2015 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

# For System Rescue CD 4.5.2 (Alternate Kernel - x86_64)
TAIL="alt452-amd64"
KERNEL="linux-${PV}-${TAIL}"
KERNEL_CONF="kernel-${PV}-${TAIL}.conf"
_KV="3.18"
KERNEL_FILE="linux-${_KV}.tar.xz"
FEDORA_NUMBER="20"

DESCRIPTION="Kernel Sources and Patches for the System Rescue CD Alternate Kernel"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="mirror://kernel/linux/kernel/v3.x/${KERNEL_FILE}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="-* ~amd64"

S="${WORKDIR}/${KERNEL}"

src_unpack()
{
	unpack ${KERNEL_FILE}
	mv ${KERNEL_FILE%.tar*} ${KERNEL}
}

src_prepare()
{
	epatch "${FILESDIR}/${PV}/${PN}-${_KV}-01-stable-${PV}.patch.xz"
	epatch "${FILESDIR}/${PV}/${PN}-${_KV}-02-fc${FEDORA_NUMBER}.patch.xz"
	epatch "${FILESDIR}/${PV}/${PN}-${_KV}-03-aufs.patch.xz"
	epatch "${FILESDIR}/${PV}/${PN}-${_KV}-04-reiser4.patch.xz"
}

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	# Copy kernel sources to the sandbox's /usr/src
	dodir /usr/src
	cp -r "${S}" "${D}/usr/src"

	# Clean kernel sources directory and copy configuration file
	cd "${D}/usr/src/${KERNEL}"
	make distclean
	cp "${FILESDIR}/${PV}/${KERNEL_CONF}" .config

	# Change local version
	sed -i -e "s%CONFIG_LOCALVERSION=\"\"%CONFIG_LOCALVERSION=\"-${TAIL}\"%" .config

	# Remove old/pre-defined initramfs path
	sed -i -e "s%CONFIG_INITRAMFS_SOURCE=\"/var/tmp/genkernel/initramfs-${PV}-${TAIL}.cpio\"%CONFIG_INITRAMFS_SOURCE=\"\"%" .config

	# Set CONFIG_USER_NS (User Namespaces) to no
	sed -i -e "s%CONFIG_USER_NS=y%CONFIG_USER_NS=n%" .config
}
