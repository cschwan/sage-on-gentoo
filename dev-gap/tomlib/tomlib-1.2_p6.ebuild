# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Library of Tables of Marks"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.8.6
SRC_URI="https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p6_2016_11_12-14_25.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/atlasrep:${SLOT}"

S="${WORKDIR}/gap4r8/pkg/${PN}"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r data doc gap tst
	doins *.g

	dodoc README
}
