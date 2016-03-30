# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib

DESCRIPTION="Computing the Automorphism Group of a p-Group"
HOMEPAGE="http://www.gap-system.org/Packages/autpgrp.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc html"

DEPEND="sci-mathematics/gap"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins *.g
	doins -r gap

	if use doc ; then
		insinto /usr/share/doc/gap/"${P}"
		doins -r doc/*
	fi

	if use html ; then
		insinto /usr/share/doc/gap/html/"${P}"
		doins -r htm/*
	fi
}
