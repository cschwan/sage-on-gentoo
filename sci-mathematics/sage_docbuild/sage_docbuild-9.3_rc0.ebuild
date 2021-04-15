# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

MY_PV=$(ver_rs 2 '')
MY_P="${PN}-${MY_PV}"
DESCRIPTION="sage docbuilding tools"
HOMEPAGE="https://www.sagemath.org
	https://pypi.org/project/sage-docbuild"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND=">=dev-python/sphinx-3.1.0[${PYTHON_USEDEP}]"
PDEPEND=">=sci-mathematics/sage-9.3[${PYTHON_USEDEP}]"
BDEPEND=""

PATCHES=( "${FILESDIR}/sage-9.3-linguas.patch" )

S="${WORKDIR}/${MY_P}"
