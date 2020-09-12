# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bindings for low level C library I/O routines"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.10.1:="
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md TODO"

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.0-headers.patch
	)

src_configure(){
	# We need to know GAParch to install the dynamic object in the expected location
	# "doins -r bin" would install it with wrong permissions
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--libdir="${EPREFIX}/usr/share/gap/pkg/${P}/bin/${GAParch}" \
		--with-gaproot="${EPREFIX}/usr/share/gap" \
		LIBS="-lgap" \
		ABI=""
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc example gap
	doins *.g
}
