# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="Methods to enumerate orbits"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-core-4.11.0"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md TODO"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.1-headers.patch
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

	${CC} -shared -fPIC ${CFLAGS} -o orb$(get_libname) -lgap ${LDFLAGS} src/orb.c
}

src_install(){
	default

	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	exeinto /usr/share/gap/pkg/"${P}"/bin/"${GAParch}"
	doexe orb$(get_libname)

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc examples gap
	doins *.g
}
