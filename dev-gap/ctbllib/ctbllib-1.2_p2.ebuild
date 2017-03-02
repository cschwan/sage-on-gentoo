# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MY_PV=$(replace_version_separator 1 'r' $(delete_version_separator 2 ) )
DESCRIPTION="The GAP Character Table Library"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r data dlnames doc gap4 htm tst
	doins *.g

	dodoc README
}
