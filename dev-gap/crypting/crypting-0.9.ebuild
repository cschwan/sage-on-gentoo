# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="Hashes and Crypto in GAP"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}"
RDEPEND="${DEPEND}
	dev-gap/GAPDoc:${SLOT}"

DOCS="README.md LICENSE COPYRIGHT.md"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-headers.patch
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
