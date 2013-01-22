# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_DEPEND="2:2.7:2.7"
PYTHON_USE_WITH="sqlite"

inherit python

MY_P="elliptic_curves-${PV}"

DESCRIPTION="Sage's elliptic curves databases"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

src_install() {
	SAGE_SHARE="${ED}/usr/share/sage" "$(PYTHON)" spkg-install
}
