# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Toric"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="toric varieties and some combinatorial geometry computations"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.10.0
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="MIT"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${MY_P}"

DOCS="CHANGES README LICENSE"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc lib
	doins *.g
}
