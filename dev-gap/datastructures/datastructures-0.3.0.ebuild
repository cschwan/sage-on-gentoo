# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Collection of standard data structures for GAP"
HOMEPAGE="https://gap-packages.github.io/datastructures/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/datastructures/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0"
RDEPEND="${DEPEND}
	>=dev-gap/GAPDoc-1.6.6"

DOCS="CHANGES.md README.md"

GAP_PKG_OBJS="doc gap"

src_prepare() {
	default

	cp "${EPREFIX}/usr/share/gap/etc/Makefile.gappkg" . || die "failed to replace Makefile.gappkg"
}

src_configure() {
	# Not a real configure script
	# The argument is the folder with sysinfo.gap
	./configure $(gap_sysinfo_loc)
}

src_compile() {
	emake V=1
}
