# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg toolchain-funcs

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="https://www.gap-system.org/Packages/guava.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-mathematics/gap-4.12.2"
RDEPEND="${DEPEND}"

DOCS=( README.md CHANGES HISTORY )

PATCHES=(
	"${FILESDIR}"/${PN}-3.15-makefile.patch
	)

GAP_PKG_OBJS="doc lib tbl"

src_prepare() {
	default
	# Remove temporary files in src/leon/.
	rm src/leon/src/stamp-h1 || die
}

src_configure() {
	# Not a real autoconf configure script
	# The argument is the folder containing sysinfo.gap
	./configure $(gap_sysinfo_loc)

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
