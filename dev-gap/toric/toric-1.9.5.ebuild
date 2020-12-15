# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Toric"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="toric varieties and some combinatorial geometry computations"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-core-4.11.0"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES README.md LICENSE"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc lib
	doins *.g
}
