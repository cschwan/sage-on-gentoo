# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="An extension class for memory aalocation in cython"
HOMEPAGE="https://pypi.org/project/memory_allocator/
	https://github.com/sagemath/memory_allocator"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
BDEPEND=""

python_test() {
	# . is search before PYTHONPATH
	mv memory_allocator mv_memory_allocator
	${EPYTHON} test.py
	mv mv_memory_allocator memory_allocator
}
