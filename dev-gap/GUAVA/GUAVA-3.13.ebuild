# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools toolchain-funcs

MY_PN="${PN,,}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="http://www.gap-system.org/Packages/guava.html https://osj1961.github.io/guava/"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.gz/packages/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.8"
RDEPEND="${DEPEND}"

RESTRICT=mirror

DOCS=( {CHANGES,HISTORY,README}.${MY_PN} )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default_src_prepare

	# Don't call autoreconf in src_compile().
	sed -i -e 's| autoreconf[^;]*;||g' Makefile.in || die

	# Don't call src/leon/configure in src_compile().
	sed -i -e 's| ./configure;||g' Makefile.in || die

	# There's no Makefile.am in src/leon/.
	sed -i -e '/AM_INIT_AUTOMAKE/d' src/leon/configure.ac || die

	# Remove temporary files in src/leon/.
	rm -r src/leon/{autom4te.cache,src/stamp-h1} src/leon/src/*~ || die

	cd src/leon/ || die
	eautoreconf
}

src_configure() {
	econf "${EPREFIX}/usr/$(get_libdir)/gap"

	cd src/leon/ || die
	econf
}

src_compile() {
	# COMPILE, COMPOPT, LINKOPT are needed to compile the code in src/leon/.
	emake -j1 \
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		COMPILE="$(tc-getCC)" COMPOPT="${CFLAGS} -c" LINKOPT="${LDFLAGS}"
}

src_install() {
	insinto /usr/$(get_libdir)/gap/pkg/${MY_P}
	doins -r bin/ doc/ lib/ tbl/ tst/
	doins {PackageInfo,init,read}.g

	einstalldocs
}
