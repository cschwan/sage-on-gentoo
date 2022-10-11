# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bindings for low level C library I/O routines"
HOMEPAGE="https://gap-packages.github.io/io/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-core-4.11.1"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.1-headers.patch
)

src_prepare(){
	default

	# copy Makefile.gappkg in place
	cp "${EPREFIX}/usr/share/gap/etc/Makefile.gappkg" . || die "couldn't copy sample makefile.gappkg"
}

src_configure(){
	# We need to know GAParch to install the dynamic object in the expected location
	# "doins -r bin" would install it with wrong permissions
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--with-gaproot="${EPREFIX}/usr/share/gap"
}

src_install(){
	# We cannot use default anymore as the Makefile doesn't have an install target
	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc example gap
	doins *.g
	# install extension
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	exeinto "/usr/share/gap/pkg/${P}/bin/${GAParch}"
	doexe "bin/${GAParch}/${PN}.so"
}
