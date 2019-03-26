# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lie AlGebras and UNits of group Algebras"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.10.1
	>=dev-gap/GAPDoc-1.6.2"

DOCS="ChangeLog README.md"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc lib
	doins *.g
}
