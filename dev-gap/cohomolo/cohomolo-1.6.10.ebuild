# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg toolchain-funcs

DESCRIPTION="Cohomology groups of finite groups on finite modules"
HOMEPAGE="https://www.gap-system.org/Packages/cohomolo.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md"
HTML_DOCS=htm/*

GAP_PKG_OBJS="doc gap testdata standalone"

pkg_setup() {
	tc-export CC
}

src_configure() {
	# Not a real configure script
	# The argument is folder containing sysinfo.gap
	./configure $(gap_sysinfo_loc)
}

src_compile() {
	default

	# Remove standalone/progs.d so that it is not installed.
	# This is the source code for executable built in the bin folder.
	rm -rf standalone/progs.d
}
