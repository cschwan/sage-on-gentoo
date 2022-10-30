# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg toolchain-funcs multilib

DESCRIPTION="Hashes and Crypto in GAP"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0"
RDEPEND="${DEPEND}
	>=dev-gap/GAPDoc-1.6.6"

DOCS="README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-headers.patch
	)

GAP_PKG_OBJS="doc gap"
GAP_PKG_EXE="crypting$(get_libname)"

pkg_setup() {
	tc-export CC
}

src_prepare() {
	default

	# fake configure. Remove to avoid problems in later phases
	rm configure Makefile.in || die "Failed to remove build system"
}

src_compile() {
	default

	${CC} -shared -fPIC ${CFLAGS} -o crypting$(get_libname) -lgap ${LDFLAGS} src/crypting.c
}
