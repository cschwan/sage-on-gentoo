# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python bindings for lrcalc"
HOMEPAGE="https://bitbucket.org/asbuch/lrcalc"
# We need to distinguish from lrcalc sources
SRC_URI="$(pypi_sdist_url) -> ${PN}_python-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="~sci-mathematics/lrcalc-${PV}
	>=dev-python/cython-0.29.25[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
