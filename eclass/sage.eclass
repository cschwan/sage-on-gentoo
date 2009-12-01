# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

# @ECLASS: sage.eclass
# @MAINTAINER:
# Francois Bissey <f.r.bissey@massey.ac.nz>
# Christopher Schwan <cschwan@students.uni-mainz.de>
#
# Original authors: Francois Bissey <f.r.bissey@massey.ac.nz>
#	Christopher Schwan <cschwan@students.uni-mainz.de>
# @BLURB: This eclass provides tools to ease the installation of sage spkg
# @DESCRIPTION:
# The sage eclass is designed to allow easier installation of
# spkg from the sage mathematical system and their incorporation into
# the Gentoo Linux system.
#
# It inherits eutils
# The following variables need to be defined:
#
# SAGE_VERSION
#
# and optionally
#
# SAGE_PACKAGE

inherit eutils

SPKG_URI="http://www.sagemath.org/packages/standard"
SAGE_LOCAL="/usr/lib/sage/local"
SAGE_ROOT="/usr/lib/sage"
SAGE_DATA="/usr/lib/sage/data"

SAGE_P="sage-${SAGE_VERSION}"

HOMEPAGE="http://www.sagemath.org/"
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/${SAGE_P}.tar"

RESTRICT="mirror"

spkg_unpack() {
	# untar spkg and and remove it
	tar -xf "$1.spkg"
	rm "$1.spkg"
	cd "$1"
}

spkg_pack() {
	# tar patched dir and remove it
	cd ..
	tar -cf "$1.spkg" "$1"
	rm -rf "$1"
}

# patch one of sage's spkgs. $1: spkg name, $2: patch name
spkg_patch() {
	spkg_unpack "$1"

	epatch "$2"

	spkg_pack "$1"
}

spkg_sed() {
	spkg_unpack "$1"

	SPKG="$1"
	shift 1
	sed "$@" || die "sed failed"

	spkg_pack "${SPKG}"
}

spkg_nested_sed() {
	spkg_unpack "$1"
	spkg_unpack "$2"

	SPKG1="$1"
	SPKG2="$2"
	shift 2
	sed "$@" || die "sed failed"

	spkg_pack "${SPKG2}"
	spkg_pack "${SPKG1}"
}

spkg_nested_patch() {
	spkg_unpack "$1"
	spkg_unpack "$2"

	epatch "$3"

	spkg_pack "$2"
	spkg_pack "$1"
}

sage_src_unpack() {
	cd "${WORKDIR}"

	# unpack spkg-file from tar
	tar -xf "${DISTDIR}/${A}" --strip-components 3 \
		"${SAGE_P}/spkg/standard/${SAGE_PACKAGE}.spkg"

	# unpack spkg-file
	tar -xjf "${SAGE_PACKAGE}.spkg"

	# remove spkg-file
	rm "${SAGE_PACKAGE}.spkg"

	# set Sage's FILESDIR
	if [[ -d "${WORKDIR}/${SAGE_PACKAGE}/patches" ]]; then
		SAGE_FILESDIR="${WORKDIR}/${SAGE_PACKAGE}/patches"
	elif [[ -d "${WORKDIR}/${SAGE_PACKAGE}/patch" ]]; then
		SAGE_FILESDIR="${WORKDIR}/${SAGE_PACKAGE}/patch"
	fi

	# set correct source path
	if [[ -d "${WORKDIR}/${SAGE_PACKAGE}/src" ]]; then
		S="${WORKDIR}/${SAGE_PACKAGE}/src"
	fi
}

if [[ -n "${SAGE_PACKAGE}" ]]; then
	S="${WORKDIR}/${SAGE_PACKAGE}"

	EXPORT_FUNCTIONS src_unpack
fi
