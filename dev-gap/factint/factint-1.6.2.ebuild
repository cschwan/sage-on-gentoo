# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="FactInt"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Advanced Methods for Factoring Integers"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SLOT="4.10.0"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${SLOT})/tar.bz2/gap-${SLOT}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/GAPDoc:${SLOT}"

S="${WORKDIR}/gap-${SLOT}/pkg/${MY_P}"

DOCS="README.md CHANGES"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc lib tables
	doins *.g
}
