# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 1 'r' $(ver_rs 2 ''))
DESCRIPTION="A GAP Interface to the Atlas of Group Representations"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SLOT="4.10.0"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${SLOT})/tar.bz2/gap-${SLOT}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:0
	net-misc/wget"

S="${WORKDIR}/gap-${SLOT}/pkg/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5_p0-local.patch
	)

DOCS="README"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r bibl datagens dataword doc gap etc
	doins *.g
}
