# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Character Table Library"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://files.gap-system.org/gap4/tar.bz2/packages/ctbllib-1r2p2.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( sci-mathematics/gap sci-mathematics/gap-core )
	>=dev-gap/GAPDoc-1.6.2"

DOCS="README"
HTML_DOCS=htm/*

S="${WORKDIR}/${PN}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r data dlnames doc gap4
	doins *.g
}
