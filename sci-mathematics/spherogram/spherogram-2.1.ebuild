# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Python module for dealing with planar diagrams arising in 3-dimensional topology"
HOMEPAGE="https://github.com/3-manifolds/Spherogram
	https://pypi.org/project/spherogram/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="sci-mathematics/planarity
	dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=sci-mathematics/snappy-3.0[${PYTHON_USEDEP}]
	>=sci-mathematics/snappy_manifolds-1.1.2[${PYTHON_USEDEP}]
	>=sci-mathematics/knot_floer_homology-1.1[${PYTHON_USEDEP}]"
# uses sage as a proxy for planarity install detection
BDEPEND="test? ( sci-mathematics/snappy_manifolds[${PYTHON_USEDEP}]
		sci-mathematics/knot_floer_homology[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PN}-1.8.3-unsage.patch )

python_test(){
	"${EPYTHON}" -m spherogram.test || die "test failed with ${EPYTHON}"
}
