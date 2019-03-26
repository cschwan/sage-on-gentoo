# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Graphs, digraphs, and multidigraphs in GAP"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/Digraphs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.10.1
	sci-mathematics/planarity
	sci-libs/bliss"
RDEPEND="${DEPEND}
	>=dev-gap/io-4.5.4
	>=dev-gap/orb-4.8.2"

DOCS="CHANGELOG.md README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-0.15.0-system_pkg.patch
	)

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	# We need to know GAParch to install the dynamic object in the expected location
	# "doins -r bin" would install it with wrong permissions
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--libdir="${EPREFIX}/usr/share/gap/pkg/${P}/bin/${GAParch}" \
		--with-gaproot="${EPREFIX}/usr/share/gap" \
		LIBS="-lbliss -lplanarity -lgap" \
		ABI=""
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc gap
	doins *.g
}
