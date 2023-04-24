# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="cython interface to primecount"
HOMEPAGE="https://github.com/dimpase/primecountpy https://pypi.org/project/primecountpy/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-mathematics/primecount-7.2
	>=dev-python/cython-0.29.25[${PYTHON_USEDEP}]
	>=dev-python/cysignals-1.11.2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
