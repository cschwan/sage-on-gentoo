# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Bindings for low level C library I/O routines"
HOMEPAGE="https://gap-packages.github.io/io/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0:="
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.1-headers.patch
)

GAP_PKG_OBJS="doc example gap"

src_prepare() {
	default

	# copy Makefile.gappkg in place
	cp "${EPREFIX}/usr/share/gap/etc/Makefile.gappkg" . || die "couldn't copy sample makefile.gappkg"
}

src_configure() {
	econf \
		--with-gaproot="$(gap_sysinfo_loc)"
}
