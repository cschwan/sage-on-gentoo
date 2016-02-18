# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit git-r3 distutils-r1 autotools

DESCRIPTION="interrupt and signal handling for Cython"
HOMEPAGE="https://github.com/sagemath/cysignals"
EGIT_REPO_URI="git://github.com/sagemath/cysignals"
EGIT_BRANCH=master

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-python/cython-0.23.4-r2
	>=sci-mathematics/pari-2.7.0"
RDEPEND="${DEPEND}"

src_prepare(){
	eautoreconf
}

python_test(){
	PATH="${BUILD_DIR}/scripts:${PATH}" "${EPYTHON}" -m doctest "${S}"/src/cysignals/*.pyx
}
