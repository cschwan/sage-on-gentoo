# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Hashes and Crypto in GAP"
HOMEPAGE="https://www.gap-system.org/Packages/crypting.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-mathematics/gap-4.12.0"
RDEPEND="${DEPEND}
	>=dev-gap/GAPDoc-1.6.6"

DOCS="README.md"

GAP_PKG_OBJS="doc gap"

src_prepare() {
	default

	# copy Makefile.gappkg in place
	cp "${EPREFIX}/usr/share/gap/etc/Makefile.gappkg" . || die "couldn't copy sample makefile.gappkg"
}

src_configure() {
	# not a real (auto)configure script
	./configure \
		--with-gaproot="$(gap_sysinfo_loc)"
}
