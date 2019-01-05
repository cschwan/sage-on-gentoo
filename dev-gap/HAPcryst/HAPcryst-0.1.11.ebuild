# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 1- '_' )
DESCRIPTION="A HAP extension for crytallographic groups"
HOMEPAGE="http://www.gap-system.org/Packages/hapcryst.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}${MY_PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:0
	dev-gap/hap:0
	dev-gap/polycyclic:0
	dev-gap/aclib:0
	dev-gap/cryst:0
	dev-gap/polymaking:0"

S="${WORKDIR}/${PN}"

src_prepare(){
	default

	rm -f examples/3dimBieberbachFD.gap~
}

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc examples lib tst
	doins *.g

	dodoc README.HAPcryst CHANGES.HAPcryst
}
