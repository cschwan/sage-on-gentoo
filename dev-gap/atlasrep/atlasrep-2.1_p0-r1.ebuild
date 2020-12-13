# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 1 'r' $(ver_rs 2 ''))
DESCRIPTION="A GAP Interface to the Atlas of Group Representations"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="mirror://sagemath/${PN}-${MY_PV}.tar.bz2"
RESTRICT=mirror

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( <sci-mathematics/gap-4.11.0 >=sci-mathematics/gap-core-4.11.0 )
	>=dev-gap/GAPDoc-1.6.2
	>=dev-gap/io-4.6.0"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5_p0-local.patch
	)

DOCS="README.md"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r bibl dataext datagens datapkg dataword doc gap
	doins *.g
	doins atlasprm.json
}
