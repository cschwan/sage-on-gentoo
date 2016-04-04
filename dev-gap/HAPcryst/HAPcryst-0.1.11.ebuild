# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PV=$(replace_all_version_separators '_' )
DESCRIPTION="A HAP extension for crytallographic groups"
HOMEPAGE="http://www.gap-system.org/Packages/hapcryst.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}${MY_PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}
	dev-gap/hap
	dev-gap/polycyclic
	dev-gap/aclib
	dev-gap/cryst
	dev-gap/polymaking"

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
