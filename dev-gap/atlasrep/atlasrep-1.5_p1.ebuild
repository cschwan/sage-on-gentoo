# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A GAP Interface to the Atlas of Group Representations"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.8.6
SRC_URI="https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p6_2016_11_12-14_25.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	net-misc/wget"

S="${WORKDIR}/gap4r8/pkg/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5_p0-local.patch
	)

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r bibl datagens dataword doc gap tst etc
	doins *.g

	dodoc README
}
