# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Content of the KnotInfo & LinkInfo databases as lists of dictionaries"
KEYWORDS=""
HOMEPAGE="https://pypi.org/project/database-knotinfo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
PDEPEND=">=sci-mathematics/sage-9.4[${PYTHON_USEDEP}]"
BDEPEND=""
