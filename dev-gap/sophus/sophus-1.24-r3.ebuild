# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Computing in nilpotent Lie algebras"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( =sci-mathematics/gap-4.10* >=sci-mathematics/gap-core-4.11.0 )
	>=dev-gap/autpgrp-1.10"

DOCS="README"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap
	doins *.g
}
