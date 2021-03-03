# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

MY_PV=$(ver_cut 1-4 ${PV})$(ver_cut 6- ${PV})
MY_P="${PN}-system-${MY_PV}"
DESCRIPTION="a Python interface to GAP"
HOMEPAGE="https://pypi.org/project/gappy-system/
	https://github.com/embray/gappy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}-system/${MY_P}.tar.gz"

# no tests, would need pytest-cython and pytest-doctestplus
RESTRICT="test"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=sci-mathematics/gap-4.11.0"
RDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/cysignals[${PYTHON_USEDEP}]
	>=sci-mathematics/gap-4.11.0
	app-text/psutils"
BDEPEND=""

S="${WORKDIR}/${MY_P}"
