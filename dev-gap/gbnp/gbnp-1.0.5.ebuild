# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="computing Grobner bases of noncommutative polynomials"
HOMEPAGE="https://gap-packages.github.io/gbnp/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6"

DOCS="README.md README_AUTHORS Changelog"

GAP_PKG_OBJS="doc examples lib"

src_prepare() {
	default

	# The makefile is to produce the package.
	# It should not be run here.
	rm -f GNUmakefile
}
