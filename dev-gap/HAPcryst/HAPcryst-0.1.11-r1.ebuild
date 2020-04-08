# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A HAP extension for crytallographic groups"
HOMEPAGE="https://www.gap-system.org/Packages/hapcryst.html"
GAP_VERSION=4.10.0
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/hap:${SLOT}
	dev-gap/polycyclic:${SLOT}
	dev-gap/aclib:${SLOT}
	dev-gap/cryst:${SLOT}
	dev-gap/polymaking:${SLOT}"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${PN}"

DOCS="README.HAPcryst CHANGES.HAPcryst"

src_prepare(){
	default

	rm -f examples/3dimBieberbachFD.gap~
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc examples lib
	doins *.g
}
