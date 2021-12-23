# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="cython interface to primecount"
HOMEPAGE="https://github.com/dimpase/primecountpy https://pypi.org/project/primecountpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-mathematics/primecount-7.2
	>=dev-python/cython-0.29.25[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
