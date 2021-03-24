# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Python module for dealing with planar diagrams arising in 3-dimensional topology"
HOMEPAGE="https://github.com/3-manifolds/Spherogram
	https://pypi.org/project/spherogram/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-mathematics/planarity
	dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sci-mathematics/snappy[${PYTHON_USEDEP}]
	sci-mathematics/snappy_manifolds[${PYTHON_USEDEP}]"
# uses sage as a proxy for planarity install detection
BDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-1.8.3-unsage.patch )

python_test(){
	python -m spherogram.test
}
