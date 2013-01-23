# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

MY_P="conway_polynomials-${PV}"

DESCRIPTION="Sage's conway polynomial database"
HOMEPAGE="http://www.sagemath.org"
#SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"
SRC_URI="http://wstein.org/home/ohanar/spkgs/conway_polynomials-0.4.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND="sci-mathematics/sage"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	sed \
		-e "s:from sage.all:from sage.structure.sage_object:g" \
		-e "/from sage.misc.misc import SAGE_SHARE/d" \
		-e "s:join(SAGE_SHARE,:join(\'${ED}usr/share/sage\',:g" \
		-e "/print p/d" \
		-i spkg-install
}

src_install() {
	./spkg-install
}
