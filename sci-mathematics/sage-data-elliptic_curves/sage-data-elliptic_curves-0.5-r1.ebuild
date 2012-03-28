# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7:2.7"
PYTHON_USE_WITH="sqlite"

inherit python eutils

MY_P="elliptic_curves-${PV}"
SAGE_P="sage-5.0.beta10"

DESCRIPTION="Sage's elliptic curves databases"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare(){
	epatch "${FILESDIR}"/permission.patch
}

src_install() {
	SAGE_DATA="${ED}/usr/share/sage/data" "$(PYTHON)" spkg-install
}
