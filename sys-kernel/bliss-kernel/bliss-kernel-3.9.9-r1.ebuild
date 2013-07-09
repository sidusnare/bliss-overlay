# Copyright (C) 2013 Jonathan Vasquez <jvasquez1011@gmail.com>
# Distributed under the terms of the Simplified BSD License.

EAPI="4"

inherit eutils mount-boot

# Variables
_LV="FB.02"						# Local Version
_PLV="${PV}-${_LV}"				# Package Version + Local Version (Module Dir)
_MD="/lib/modules/${_PLV}"		# Modules Directory
_KN="linux-${_PLV}"				# Kernel Directory Name
_KD="/usr/src/${_KN}"			# Kernel Directory
_CONF="bliss.conf"				# Blacklist

# Modules Link
_MOD_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/${PN}/${_PLV}/modules-${_PLV}.tar.bz2"

# Main
DESCRIPTION="Precompiled Vanilla Kernel"
HOMEPAGE="http://funtoo.org/"
SRC_URI="http://ftp.osuosl.org/pub/funtoo/distfiles/${PN}/${_PLV}/kernel-${_PLV}.tar.bz2
		 http://ftp.osuosl.org/pub/funtoo/distfiles/${PN}/${_PLV}/headers-${_PLV}.tar.bz2"

RESTRICT="mirror strip"
LICENSE="GPL-2"
SLOT="${_PLV}-${PR}"
KEYWORDS="amd64"

IUSE="symlink"

S="${WORKDIR}"

src_compile()
{
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	# Install Kernel
	insinto /boot
	doins ${S}/kernel/*

	# Install Headers
	dodir /usr/src
	cp -r ${S}/headers/${_KN} ${D}/usr/src

	# Install Blacklist
	insinto /etc/modprobe.d/
	doins ${FILESDIR}/${_CONF}
}

pkg_preinst()
{
	# Download the bliss modules here so that portage doesn't track the modules
	# This has the effect of portage not wanting to re-emerge the old bliss-modules
	# package every single time you do emerge @module-rebuild.

	# Name of folder that will hold bliss-modules
	local _F="bliss-kernel"

	cd /usr/src/ || die "Cannot change into /usr/src directory!"

	einfo "Checking to see if you already downloaded the kernel modules..."

	if [[ -d ${_F} ]]; then
		cd ${_F}

		if [[ ! -f modules-${_PLV}.tar.bz2 ]]; then
			einfo "Downloading modules for ${PV} to /usr/src/${_F}..."
			wget ${_MOD_URI}
		fi
	else
		mkdir ${_F} && cd ${_F}
		einfo "Downloading modules for ${PV} to /usr/src/${_F}..."
		wget ${_MOD_URI}
	fi

	tar xf modules-${_PLV}.tar.bz2

	einfo "Checking to see if you already have the modules installed..."

	if [[ -d /lib/modules ]]; then
		if [[ ! -d ${_MD} ]]; then
			einfo "/lib/modules/${_PLV} doesn't exist. Installing modules now..."
			cp -r modules/${_PLV} /lib/modules
		else
			einfo "You already have the modules installed. Not installing."
		fi
	else
		einfo "/lib/modules/ directory doesn't exist. Creating..."
		mkdir /lib/modules && cp -r modules/${_PLV} /lib/modules
	fi
}

pkg_postinst()
{
	# Set the kernel symlink if symlink use is set or it doesn't exist
	if use symlink || [[ ! -h "/usr/src/linux" ]]; then
		einfo "Creating symlink to ${_KD}"
		eselect kernel set ${_KN}
	fi

	# Delete the extract modules directory in /usr/src/bliss-kernel
	if [[ -d /usr/src/bliss-kernel/modules ]]; then
		rm -rf /usr/src/bliss-kernel/modules
	fi
}
