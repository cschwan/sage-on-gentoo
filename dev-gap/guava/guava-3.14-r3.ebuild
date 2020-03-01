# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="http://www.gap-system.org/Packages/guava.html https://osj1961.github.io/guava/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.10.1"
RDEPEND="${DEPEND}"

RESTRICT=primaryuri

DOCS=( {CHANGES,HISTORY,README}.${PN} )

PATCHES=(
	"${FILESDIR}"/${PN}-3.14-build.patch
	)

src_prepare() {
	default
	# Remove temporary files in src/leon/.
	rm src/leon/src/stamp-h1 || die

	cd src/leon/ || die
	eautoreconf
}

src_configure() {
	# Not a real autoconf configure script
	econf "${EPREFIX}/usr/share/gap"

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
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc lib tbl
	doins *.g
	# installing executables
	source "${EPREFIX}/usr/share/gap/sysinfo.gap"
	exeinto /usr/share/gap/pkg/"${P}/bin/${GAParch}"
	doexe bin/"${GAParch}"/*
}
