# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

DESCRIPTION="GRaph Algorithms using PErmutation groups"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="bliss"

RDEPEND=">=sci-mathematics/gap-core-4.11.0
	bliss? ( >=sci-libs/bliss-0.73 )
	!bliss? ( sci-mathematics/nauty )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.1-exec.patch
	)

DOCS="README.md CHANGES.md"
HTML_DOCS=htm/*

src_prepare(){
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

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc grh lib
	doins *.g
}
