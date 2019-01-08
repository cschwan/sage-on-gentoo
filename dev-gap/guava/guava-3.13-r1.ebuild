# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

MY_PN="guava"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="http://www.gap-system.org/Packages/guava.html https://osj1961.github.io/guava/"
GAP_VERSION=4.8.6
SRC_URI="https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p6_2016_11_12-14_25.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}"
RDEPEND="${DEPEND}"

RESTRICT=mirror

DOCS=( {CHANGES,HISTORY,README}.${MY_PN} )

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.13-build.patch
	)

S="${WORKDIR}/gap4r8/pkg/${MY_P}"

src_prepare() {
	default
	# Remove temporary files in src/leon/.
	rm -r src/leon/{autom4te.cache,src/stamp-h1} src/leon/src/*~ || die

	cd src/leon/ || die
	eautoreconf
}

src_configure() {
	# Not a real autoconf configure script
	econf "${EPREFIX}/usr/$(get_libdir)/gap"

	cd src/leon/ || die
	# real autoconf configure script
	econf
}

src_compile() {
	# COMPILE, COMPOPT, LINKOPT are needed to compile the code in src/leon/.
	emake \
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		COMPILE="$(tc-getCC)" COMPOPT="${CFLAGS} -c" LINKOPT="${LDFLAGS}"
}

src_install() {
	insinto /usr/$(get_libdir)/gap/pkg/${MY_P}
	doins -r bin/ doc/ lib/ tbl/ tst/
	doins {PackageInfo,init,read}.g

	einstalldocs
}
