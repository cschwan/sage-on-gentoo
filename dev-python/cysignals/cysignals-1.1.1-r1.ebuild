# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="interrupt and signal handling for Cython"
HOMEPAGE="https://github.com/sagemath/cysignals"
SRC_URI="https://github.com/sagemath/cysignals/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-python/cython-0.24
	>=sci-mathematics/pari-2.7.0"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-libpath.patch
	"${FILESDIR}"/${PN}-1.1.1-helper_loc.patch
	)

python_test(){
	PATH="${BUILD_DIR}/scripts:${PATH}" "${EPYTHON}" -m doctest "${S}"/src/cysignals/*.pyx
}
