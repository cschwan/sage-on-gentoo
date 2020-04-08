# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generate documentation from GAP source code"
HOMEPAGE="https://www.gap-system.org/Packages/autodoc.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.10.2
	>=dev-gap/GAPDoc-1.6.2"

DOCS="CHANGES README.md TODO"

src_prepare(){
	default

	rm -f makefile
}
src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap
	doins *.g
}
