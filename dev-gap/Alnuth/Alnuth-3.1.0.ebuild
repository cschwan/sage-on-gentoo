# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="alnuth-${PV}"
DESCRIPTION="Algebraic number theory and an interface to PARI/GP"
HOMEPAGE="http://www.gap-system.org/Packages/alnuth.html"
SLOT="4.10.0"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${SLOT})/tar.bz2/gap-${SLOT}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="CHANGES README.md"
HTML_DOCS=htm/*

RDEPEND="sci-mathematics/gap:${SLOT}
	>=sci-mathematics/pari-2.5.0
	dev-gap/polycyclic:${SLOT}"

S="${WORKDIR}/gap-${SLOT}/pkg/${MY_P}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc exam gap gp
	doins *.g
}
