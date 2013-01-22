# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs versionator multilib

MY_P="cliquer-$(replace_version_separator 2 '.')"

DESCRIPTION="Cliquer is a set of C routines for finding cliques in an arbitrary weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}/src

pkg_setup() {
	tc-export CC
}

src_prepare() {
	# patch Makefile
	epatch ../patches/Makefile.patch
	epatch ../patches/graph.c.patch
	epatch ../patches/cl.c.patch

	cp ../patches/cl.h .

	# fix QA Notice: [..] runtime text relocations
	append-cflags -fPIC

	# replace variable with flags fixing QA warnings
	if  [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:\$(SAGESOFLAGS) -o \$\@:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libcliquer.dylib -o libcliquer.dylib:g" Makefile \
			|| die "failed to add flags for linking shared library"
	else
		sed -i "s:\$(SAGESOFLAGS):-shared -Wl,-soname,libcliquer.so:g" Makefile \
			|| die "failed to add flags for linking shared library"
	fi

	# remove main function - useless in libraries
	epatch "${FILESDIR}"/${PN}-1.21_p0-remove-main.patch
}

src_test() {
	PATH="$PATH:." emake test
}

src_install() {
	insinto /usr/include/cliquer
	doins cl.h cliquer.h cliquerconf.h graph.h misc.h reorder.h set.h
	dolib libcliquer$(get_libname)
}
