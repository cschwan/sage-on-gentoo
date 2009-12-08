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

_SAGE_UNPACKED_SPKGS=( )

_sage_package_unpack() {
	# make sure spkg is unpacked
	if [[ ! -d "$1" ]] ; then
		ebegin "Unpacking $1"
		tar -xf "$1.spkg"
		eend

		# remove the spkg file
		rm "$1.spkg"

		# record unpacked spkg
		_SAGE_UNPACKED_SPKGS=( ${_SAGE_UNPACKED_SPKGS[@]} $1 )
	fi
}

# patch one of sage's spkgs. $1: spkg name, $2: patch name
sage_package_patch() {
	_sage_package_unpack "$1"

	# change to the spkg's directory, apply patch and move back
	cd "$1"
	epatch "$2"
	cd ..
}

sage_package_sed() {
	_sage_package_unpack "$1"

	cd "$1"
	shift 1
	sed "$@" || die "sed failed"
	cd ..
}

sage_package_cp() {
	_sage_package_unpack "$1"

	cd "$1"
	shift 1
	cp "$@" || die "cp failed"
	cd ..
}

sage_package_nested_sed() {
	_sage_package_unpack "$1"

	cd "$1"
	tar -xf "$2.spkg" || die "tar failed"
	rm "$2.spkg" || die "rm failed"
	cd "$2"
	SPKG="$2"
	shift 2
	sed "$@" || die "sed failed"
	cd ..
	tar -cf "${SPKG}.spkg" "${SPKG}"
	rm -rf "${SPKG}"
	cd ..
}

sage_package_nested_patch() {
	_sage_package_unpack "$1"

	cd "$1"
	tar -xf "$2.spkg" || die "tar failed"
	rm "$2.spkg" || die "rm failed"
	cd "$2"
	epatch "$3"
	cd ..
	tar -cf "$2.spkg" "$2" || die "tar failed"
	rm -rf "$2"
	cd ..
}

sage_package_finish() {
	ebegin "Packing Sage packages"
	for i in ${_SAGE_UNPACKED_SPKGS[@]} ; do
		tar -cf "$i.spkg" "$i"
		rm -rf "$i"
	done
	eend
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
