# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="This sagemath package adds various functionality"
HOMEPAGE="https://github.com/flatsurf/surface-dynamics
	https://pypi.org/project/surface-dynamics/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sage-9.7[${PYTHON_USEDEP}]
	dev-python/pplpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	<dev-python/cython-3.0.0"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.7-sage9.7compat.patch
	)
