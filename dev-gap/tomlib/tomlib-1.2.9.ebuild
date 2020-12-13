# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Library of Tables of Marks"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-core-4.11.0
	>=dev-gap/atlasrep-1.5_p1"

DOCS="README.md"
HTML_DOCS=htm/*

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc gap
	doins *.g
}
