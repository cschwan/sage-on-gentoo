# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="a full featured graphical editor for knot and link projections"
HOMEPAGE="https://pypi.org/project/plink/
	https://github.com/3-manifolds/PLink"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
