# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit elisp distutils-r1

DESCRIPTION="An emacs mode for sage"
HOMEPAGE="http://wiki.sagemath.org/sage-mode"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="!app-emacs/python-mode"
RDEPEND="${DEPEND}"
SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}"/src/python

python_compile_all() {
	pushd ../emacs
	elisp_src_compile
	popd
}

python_install_all() {
	pushd ../emacs
	elisp_src_install
	popd
	distutils-r1_python_install_all
}
