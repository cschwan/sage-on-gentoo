# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Python module for dealing with planar diagrams arising in 3-dimensional topology"
HOMEPAGE="https://github.com/3-manifolds/Spherogram
	https://pypi.org/project/spherogram/"
# Not using pypi. Ship with cythonized files without the sources.
SRC_URI="https://github.com/3-manifolds/Spherogram/archive/refs/tags/${PV}_as_released.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/Spherogram-${PV}_as_released"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="sci-mathematics/planarity"
RDEPEND="${DEPEND}
	>=sci-mathematics/snappy-3.0[${PYTHON_USEDEP}]
	>=sci-mathematics/snappy-manifolds-1.1.2[${PYTHON_USEDEP}]
	>=sci-mathematics/knot_floer_homology-1.1[${PYTHON_USEDEP}]"
# uses sage as a proxy for planarity install detection
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	test? ( sci-mathematics/snappy-manifolds[${PYTHON_USEDEP}]
		sci-mathematics/knot_floer_homology[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-unsage.patch
	"${FILESDIR}"/python3.12.patch
)

python_test(){
	"${EPYTHON}" -m spherogram.test || die "test failed with ${EPYTHON}"
}
