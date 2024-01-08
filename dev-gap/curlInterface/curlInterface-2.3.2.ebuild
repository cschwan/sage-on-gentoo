# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP package wrapper to download files over http(s) and ftp"
HOMEPAGE="https://www.gap-system.org/Packages/curlinterface.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-mathematics/gap-4.12.2"
RDEPEND="${DEPEND}
	>=dev-gap/GAPDoc-1.6.6"

DOCS=( README.md CHANGES )

GAP_PKG_OBJS="doc gap"

src_prepare() {
	default

	cp "${ESYSROOT}/usr/share/gap/etc/Makefile.gappkg" . || die "failed to replace Makefile.gappkg"
}

src_configure() {
	# Incredibly a real configure script
	econf \
	    --with-gaproot=$(gap_sysinfo_loc)
}
