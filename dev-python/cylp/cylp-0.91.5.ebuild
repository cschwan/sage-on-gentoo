# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python interface to coinor-cbc"
HOMEPAGE="https://github.com/coin-or/CyLP"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	=sci-libs/coinor-cbc-2.10*"
RDEPEND="${DEPEND}"

# unittest but doesn't seem to be able to find compiled modules.
RESTRICT="test"

python_compile() {
	distutils-r1_python_compile -j1
}
