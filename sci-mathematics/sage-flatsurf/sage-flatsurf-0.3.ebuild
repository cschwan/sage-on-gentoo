# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

MY_PN="sage_flatsurf"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="package for working with flat surfaces in SageMath."
HOMEPAGE="https://github.com/videlec/sage-flatsurf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sage-9.3[${PYTHON_USEDEP}]
	sci-mathematics/surface_dynamics[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

python_test(){
	sage -t --long flatsurf || die "test failed"
}
