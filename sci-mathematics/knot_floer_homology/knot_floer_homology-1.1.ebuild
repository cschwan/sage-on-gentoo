# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python module for dealing with planar diagrams arising in 3-dimensional topology"
HOMEPAGE="https://github.com/3-manifolds/knot_floer_homology
	https://pypi.org/project/knot-floer-homology/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
