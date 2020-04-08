# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MY_PN="guava"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="https://www.gap-system.org/Packages/guava.html https://osj1961.github.io/guava/"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}"
RDEPEND="${DEPEND}"

RESTRICT=primaryuri

DOCS=( {CHANGES,HISTORY,README}.${MY_PN} )

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.14-build.patch
	)

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${MY_P}"

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

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc lib tbl
	doins *.g
	# installing executables
	source "${EPREFIX}/usr/share/gap/sysinfo.gap"
	exeinto /usr/share/gap/pkg/"${MY_P}/bin/${GAParch}"
	doexe bin/"${GAParch}"/*
}
