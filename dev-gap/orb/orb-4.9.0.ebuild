# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg toolchain-funcs

DESCRIPTION="Methods to enumerate orbits"
HOMEPAGE="https://www.gap-system.org/Packages/orb.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0:="
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md TODO"

GAP_PKG_OBJS="doc examples gap"

pkg_setup() {
	tc-export CC
}

src_prepare() {
	default

	cp "${ESYSROOT}/usr/share/gap/etc/Makefile.gappkg" . || die "failed to replace Makefile.gappkg"
}

src_configure() {
	# Not a real configure script
	# The argument is the folder with sysinfo.gap
	./configure $(gap_sysinfo_loc)
}
