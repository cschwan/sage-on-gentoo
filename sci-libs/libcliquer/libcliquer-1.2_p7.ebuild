# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs versionator multilib

MY_P="cliquer-$(replace_version_separator 2 '.')"
SAGE_P="sage-4.6"

DESCRIPTION="Cliquer is a set of C routines for finding cliques in an arbitrary weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
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
	cp ../patch/Makefile . || die "failed to copy Makefile"

	# fix QA Notice: [..] runtime text relocations
	append-cflags -fPIC

	# replace variable with flags fixing QA warnings
	if  [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:\$(SAGESOFLAGS) -o libcliquer.so:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libcliquer.dylib -o libcliquer.dylib:g" Makefile \
			|| die "failed to add flags for linking shared library"
	else
		sed -i "s:\$(SAGESOFLAGS):-shared -Wl,-soname,libcliquer.so:g" Makefile \
			|| die "failed to add flags for linking shared library"
	fi

	# remove main function - useless in libraries
	epatch "${FILESDIR}"/${PN}-1.2_p6-remove-main.patch
}

src_test() {
	PATH="$PATH:." emake test
}

src_install() {
	insinto /usr/include/cliquer
	doins cl.h cliquer.h cliquerconf.h graph.h misc.h reorder.h set.h
	dolib libcliquer$(get_libname)
}
