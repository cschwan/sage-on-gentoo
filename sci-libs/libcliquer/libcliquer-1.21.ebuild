# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic

DESCRIPTION="Cliquer is a set of C routines for finding cliques in an arbitrary
weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"
SRC_URI="http://users.tkk.fi/~pat/cliquer/cliquer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# overwrite Makefile
	epatch "${FILESDIR}"/${P}-makefile.patch

	# at least amd64 needs PIC
	append-cflags -fPIC

	# add functions Sage needs
	epatch "${FILESDIR}"/${P}-sage-functions.patch

	# patch to remove main function - libraries usually dont need them (!?)
	epatch "${FILESDIR}"/${PN}-1.2.2-remove-main.patch
}

src_install() {
	insinto /usr/include/cliquer
	doins cl.h cliquer.h cliquerconf.h graph.h misc.h reorder.h set.h
	dolib libcliquer.so
}
