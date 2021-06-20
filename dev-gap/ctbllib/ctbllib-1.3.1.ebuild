# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Character Table Library"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="mirror://sagemath/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( >=sci-mathematics/gap-4.11.1 >=sci-mathematics/gap-core-4.11.1 )
	>=dev-gap/GAPDoc-1.6.2
	>=dev-gap/atlasrep-2.1"

DOCS="README.md"
HTML_DOCS=htm/*

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data dlnames doc doc2 gap4
	doins *.g
}
