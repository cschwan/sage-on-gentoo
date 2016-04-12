# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PV=$(replace_all_version_separators '_' )
DESCRIPTION="Interfacing the geometry software polymake"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}${MY_PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap
	sci-mathematics/polymake"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc lib tst
	doins *.g

	dodoc CHANGES.polymaking README.polymaking
}
