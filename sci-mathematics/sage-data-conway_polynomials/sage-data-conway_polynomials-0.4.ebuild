# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

MY_P="conway_polynomials-${PV}"
#SAGE_P="sage-5.4.rc0"

DESCRIPTION="Sage's conway polynomial database"
HOMEPAGE="http://www.sagemath.org"
#SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"
SRC_URI="http://wstein.org/home/ohanar/spkgs/conway_polynomials-0.4.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND="sci-mathematics/sage"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOT_SAGE="${S}"

src_prepare() {
	sed -i "s:join(SAGE_SHARE,:join(\'${ED}/usr/share/sage\',:g" spkg-install
}

src_install() {
	./spkg-install
}
