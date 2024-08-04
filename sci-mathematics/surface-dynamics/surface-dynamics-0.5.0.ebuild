# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="This sagemath package adds various functionality"
HOMEPAGE="https://github.com/flatsurf/surface-dynamics
	https://pypi.org/project/surface-dynamics/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sagemath-standard-9.7[${PYTHON_USEDEP}]
	dev-python/pplpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

# some tests are currently broken, possibly at the framework level
RESTRICT="test"

python_test() {
	rm -rf surface_dynamics || die
	epytest
}
