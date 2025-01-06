# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 git-r3

DESCRIPTION="Python interface to coinor-cbc"
HOMEPAGE="https://github.com/coin-or/CyLP"
EGIT_REPO_URI="https://github.com/coin-or/CyLP.git"
EGIT_BRANCH=master

LICENSE="EPL-2.0"
SLOT="0"

DEPEND="<dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	=sci-libs/coinor-cbc-2.10*"
RDEPEND="${DEPEND}"
BDEPEND=">dev-python/cython-3.0.0[${PYTHON_USEDEP}]"

# unittest but doesn't seem to be able to find compiled modules.
RESTRICT="test"

src_unpack() {
	git-r3_src_unpack

	default
}

python_compile() {
	distutils-r1_python_compile -j1
}
