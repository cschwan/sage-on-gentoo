# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="This sagemath package adds various functionality"
HOMEPAGE="https://gitlab.com/videlec/surface_dynamics"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sage-9.3[${PYTHON_USEDEP}]
	dev-python/pplpy[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""
