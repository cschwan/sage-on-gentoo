# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="This sagemath package adds various functionality"
HOMEPAGE="https://github.com/flatsurf/surface-dynamics
	https://pypi.org/project/surface-dynamics/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sage-9.5[${PYTHON_USEDEP}]
	dev-python/pplpy[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""
