# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="Hashes and Crypto in GAP"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-core-4.11.0"
RDEPEND="${DEPEND}
	>=dev-gap/GAPDoc-1.6.2"

DOCS="README.md LICENSE COPYRIGHT.md"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-headers.patch
	)

pkg_setup(){
	tc-export CC
}

src_prepare(){
	default

	# fake configure. Remove to avoid problems in later phases
	rm configure Makefile.in || die "Failed to remove build system"
}

src_compile(){
	default

	${CC} -shared -fPIC ${CFLAGS} -o crypting$(get_libname) -lgap ${LDFLAGS} src/crypting.c
}

src_install(){
	default

	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	exeinto /usr/share/gap/pkg/"${P}"/bin/"${GAParch}"
	doexe crypting$(get_libname)

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap
	doins *.g
}
