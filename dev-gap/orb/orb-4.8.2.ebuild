# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="Methods to enumerate orbits"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.1"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md TODO"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.1-headers.patch
	)

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

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
