# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Graphs, digraphs, and multidigraphs in GAP"
HOMEPAGE="https://www.gap-system.org/Packages/digraphs.html"
SLOT="0"
SRC_URI="https://github.com/digraphs/Digraphs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0
	sci-mathematics/planarity
	sci-libs/bliss"
RDEPEND="${DEPEND}
	>=dev-gap/io-4.6.0
	>=dev-gap/orb-4.8.2
	>=dev-gap/datastructures-0.2.5"

DOCS="CHANGELOG.md README.md"

PATCHES=(
	"${FILESDIR}/${PN}-1.6.1-gap_headers.patch"
)

GAP_PKG_OBJS="data doc gap notebooks"

src_configure() {
	# We need to know GAParch to install the dynamic object in the expected location
	# Unsetting ABI as gap use the variable internally.
	econf \
		--libdir="${ESYSROOT}/$(gap-pkg_path)/bin/$(gap-pkg_gaparch)" \
		--with-gaproot="$(gap_sysinfo_loc)" \
		--with-external-planarity \
		--with-external-bliss \
		LIBS="-lgap" \
		ABI=""
}
