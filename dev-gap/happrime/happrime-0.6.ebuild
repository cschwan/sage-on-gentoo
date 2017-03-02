# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a HAP extension for small prime power groups"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}
	dev-gap/hap"

S="${WORKDIR}/${PN}"

src_prepare(){
	default

	find doc -name \*.in -delete || die "failed to delete .in files"
	rm -f doc/includesourcedoc.sh
}

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc lib tst
	doins *.g

	dodoc CHANGES README
}
