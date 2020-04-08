# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="FactInt"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Advanced Methods for Factoring Integers"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/GAPDoc:${SLOT}"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${MY_P}"

DOCS="README.md CHANGES"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc lib tables
	doins *.g
}
