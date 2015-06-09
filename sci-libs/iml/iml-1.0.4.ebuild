# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils toolchain-funcs flag-o-matic

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND="dev-libs/gmp:=
	virtual/cblas
	virtual/pkgconfig"
RDEPEND="dev-libs/gmp:=
	virtual/cblas"

DOCS=( AUTHORS ChangeLog README )

#stolen from numpy
pc_libdir() {
	$(tc-getPKG_CONFIG) --libs-only-L $@ | \
		sed -e 's/^-L//' -e 's/[ ]*-L/:/g' -e 's/[ ]*$//' -e 's|^:||'
}

pc_incdir() {
	$(tc-getPKG_CONFIG) --cflags-only-I $@ | \
		sed -e 's/^-I//' -e 's/[ ]*-I/:/g' -e 's/[ ]*$//' -e 's|^:||'
}

src_configure() {
	myeconfargs=(
		--with-default="${EPREFIX}"/usr
		--with-cblas-include=$(pc_incdir cblas)
		--with-cblas-lib=$(pc_libdir cblas)
		--with-cblas="$($(tc-getPKG_CONFIG) --libs cblas)"
	)
	autotools-utils_src_configure
}
