# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs versionator

MY_P="cliquer-$(replace_version_separator 2 '.')"

DESCRIPTION="Cliquer is a set of C routines for finding cliques in an arbitrary weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

pkg_setup() {
	tc-export CC
}

src_prepare() {
	# overwrite Makefile
	cp ../patch/Makefile .

	# fix QA Notice: [..] runtime text relocations
	append-cflags -fPIC

	# replace variable with flags fixing QA warnings
	sed -i "s:\$(SAGESOFLAGS):-shared -Wl,-soname,libcliquer.so:g" Makefile \
		|| die "failed to add flags for linking shared library"

	# remove main function - useless in libraries
	epatch "${FILESDIR}"/${PN}-1.2_p6-remove-main.patch
}

src_test() {
	PATH="$PATH:." emake test || die "failed to test cliquer"
}

src_install() {
	insinto /usr/include/cliquer
	doins cl.h cliquer.h cliquerconf.h graph.h misc.h reorder.h set.h || die
	dolib libcliquer.so || die
}
