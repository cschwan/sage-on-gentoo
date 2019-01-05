# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The crystallographic groups catalog"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:0
	dev-gap/polycyclic:0"

S="${WORKDIR}"/${PN}

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc grp htm lib
	doins *.g

	dodoc Changelog README
}
