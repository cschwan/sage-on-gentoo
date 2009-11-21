# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

# The following variables need to be defined:
#
# SAGE_VERSION
#
# and optionally
#
# SAGE_PACKAGE

inherit eutils

SAGE_P="sage-${SAGE_VERSION}"

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/${SAGE_P}.tar"

RESTRICT="mirror"

sage_src_unpack() {
	cd "${WORKDIR}"

	# unpack spkg-file from tar
	tar -xf "${DISTDIR}/${A}" --strip-components 3 \
		"${SAGE_P}/spkg/standard/${SAGE_PACKAGE}.spkg"

	# unpack spkg-file
	tar -xjf "${SAGE_PACKAGE}.spkg"

	# remove spkg-file
	rm "${SAGE_PACKAGE}.spkg"

	if [[ -d "${WORKDIR}/${SAGE_PACKAGE}/patches" ]]; then
		SAGE_FILESDIR="${WORKDIR}/${SAGE_PACKAGE}/patches"
	elif [[ -d "${WORKDIR}/${SAGE_PACKAGE}/patch" ]]; then
		SAGE_FILESDIR="${WORKDIR}/${SAGE_PACKAGE}/patch"
	fi
}

if [[ -n "${SAGE_PACKAGE}" ]]; then
	S="${WORKDIR}/${SAGE_PACKAGE}/src"

	EXPORT_FUNCTIONS src_unpack
fi
