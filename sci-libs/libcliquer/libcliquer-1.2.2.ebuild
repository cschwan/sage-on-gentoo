# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=4.3.2
SAGE_PACKAGE=cliquer-1.2.p2

inherit eutils sage

DESCRIPTION="Cliquer is a set of C routines for finding cliques in an arbitrary
weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# overwrite Makefile
	cp "${SAGE_FILESDIR}"/Makefile .

	# needed on amd64
	CFLAGS="${CFLAGS} -fPIC"

	# replace variable with flags fixing QA warnings
	sed -i "s/\$(SAGESOFLAGS)/-shared -Wl,-soname,libcliquer.so/g" \
		"Makefile" || die "sed failed"

	# patch to remove main function - libraries usually dont need them (!?)
	epatch "${FILESDIR}"/${P}-remove-main.patch
}

src_test() {
	PATH="$PATH:." emake test || die "emake test failed"
}

src_install() {
	insinto /usr/include/cliquer
	doins cl.h cliquer.h cliquerconf.h graph.h misc.h reorder.h set.h
	dolib libcliquer.so
}
