# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="An extension class for memory aalocation in cython"
HOMEPAGE="https://pypi.org/project/memory-allocator/
	https://github.com/sagemath/memory_allocator"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-python/cython-0.29.30[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/cython-0.29.30[${PYTHON_USEDEP}]"
BDEPEND=""

python_test() {
	# . is searched before PYTHONPATH
	mv memory_allocator mv_memory_allocator
	${EPYTHON} test.py
	mv mv_memory_allocator memory_allocator
}
