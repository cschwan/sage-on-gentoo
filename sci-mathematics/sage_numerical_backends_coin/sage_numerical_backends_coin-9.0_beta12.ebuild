# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

MY_PV=$(ver_cut 1-2)b$(ver_cut 4)
MY_P="${PN}-${MY_PV}"
DESCRIPTION="COIN-OR mixed integer linear programming backend for SageMath"
HOMEPAGE="https://github.com/mkoeppe/sage-numerical-backends-coin"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="test"

DEPEND=">=sci-libs/coinor-cbc-2.10.5:=
	dev-python/cython[${PYTHON_USEDEP}]
	sci-mathematics/sage[${PYTHON_USEDEP}]"
BDEPEND="dev-python/pkgconfig[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

distutils_enable_tests setup.py

S="${WORKDIR}/${MY_P}"
