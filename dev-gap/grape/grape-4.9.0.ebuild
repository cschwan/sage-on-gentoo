# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg prefix

DESCRIPTION="GRaph Algorithms using PErmutation groups"
HOMEPAGE="https://www.gap-system.org/Packages/grape.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="bliss"

RDEPEND=">=sci-mathematics/gap-4.12.0
	bliss? ( >=sci-libs/bliss-0.73 )
	!bliss? ( sci-mathematics/nauty )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.9.0-exec.patch
	)

DOCS="README.md CHANGES.md"
HTML_DOCS=htm/*

GAP_PKG_OBJS="doc grh lib"

src_prepare() {
	default

	rm -f configure \
		Makefile \
		Makefile.in

	local nauty="true"
	if use bliss ; then
		nauty="false"
	fi
	sed -i "s:@nauty@:$nauty:" lib/grape.g
	eprefixify lib/grape.g
}
