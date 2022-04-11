# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

MY_PN="sage_flatsurf"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="package for working with flat surfaces in SageMath."
HOMEPAGE="https://github.com/flatsurf/sage-flatsurf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sage-9.5[${PYTHON_USEDEP}]
	sci-mathematics/surface_dynamics[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/152.patch
	)

S="${WORKDIR}/${MY_P}"

python_test(){
	sage -t --long flatsurf || die "test failed"
}
