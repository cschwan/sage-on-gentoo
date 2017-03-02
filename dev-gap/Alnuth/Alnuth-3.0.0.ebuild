# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Algebraic number theory and an interface to PARI/GP"
HOMEPAGE="http://www.gap-system.org/Packages/alnuth.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}
	>=sci-mathematics/pari-2.5.0"

PDEPEND="dev-gap/autpgrp
	dev-gap/polycyclic"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc exam gap gp htm
	doins *.g

	dodoc CHANGES README
}
