# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

MY_P="conway_polynomials-${PV}"

DESCRIPTION="Sage's conway polynomial database"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sageupstream/conway_polynomials/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	ln -s ${MY_P} src
	cp "${FILESDIR}"/spkg-install ./
}

src_install() {
	SAGE_SHARE="${ED}/usr/share/sage" "${PYTHON}" spkg-install
}
