# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Quivers and Path Algebras"
HOMEPAGE="https://folk.ntnu.no/oyvinso/QPA/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( >=sci-mathematics/gap-core-4.11.1 >=sci-mathematics/gap-4.11.1 )
	>=dev-gap/gbnp-1.0.3"

DOCS="README CHANGES"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc examples lib
	doins *.g
}
