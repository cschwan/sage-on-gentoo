# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Python module for dealing with planar diagrams arising in 3-dimensional topology"
HOMEPAGE="https://github.com/3-manifolds/knot_floer_homology
	https://pypi.org/project/knot-floer-homology/"
# Not using pypi. Ship with cythonized files without the sources.
SRC_URI="https://github.com/3-manifolds/${PN}/archive/refs/tags/${PV}_as_released.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P}_as_released"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" -m knot_floer_homology.test
}
