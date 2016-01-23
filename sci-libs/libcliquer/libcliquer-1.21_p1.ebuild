# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs versionator multilib

MY_PN="cliquer"
MY_PV="$(get_version_component_range 1-2)"
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="A set of C routines for finding cliques in an arbitrary weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"
SRC_URI="http://users.tkk.fi/~pat/cliquer/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.21-makefile.patch
	)

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	tc-export CC

	# fix QA Notice: [..] runtime text relocations
	append-cflags -fPIC
}

src_prepare() {
	default

	sed -i "s:@SHLIB@:$(get_libname ${MY_PV}):g" Makefile
	if  [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:@SHAREDFLAGS@:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libcliquer$(get_libname ${MY_PV}):" \
			Makefile
	else
		sed -i "s:@SHAREDFLAGS@:-shared -Wl,-soname,libcliquer$(get_libname ${MY_PV}):" \
			Makefile
	fi
}

src_test() {
	PATH="$PATH:." emake test
}

src_install() {
	insinto /usr/include/cliquer
	doins cliquer.h cliquerconf.h graph.h misc.h reorder.h set.h
	dolib libcliquer$(get_libname ${MY_PV})
	dosym libcliquer$(get_libname ${MY_PV}) /usr/$(get_libdir)/libcliquer$(get_libname)
}
