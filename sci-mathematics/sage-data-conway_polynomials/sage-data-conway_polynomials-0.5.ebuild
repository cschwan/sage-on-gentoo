# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit python-any-r1

MY_P="conway_polynomials-${PV}"

DESCRIPTION="Sage's conway polynomial database"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="mirror://sageupstream/conway_polynomials/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND="${PYTHON_DEPS}"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	ln -s ${MY_P} src
	cp "${FILESDIR}"/spkg-install-0.5 spkg-install

	default
}

src_install() {
	SAGE_SHARE="${ED}/usr/share/sage" "${PYTHON}" spkg-install
}
