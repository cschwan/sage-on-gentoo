# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Content of the KnotInfo & LinkInfo databases as lists of dictionaries"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
HOMEPAGE="https://pypi.org/project/database-knotinfo/"
IUSE="test"

LICENSE="GPL-3"
SLOT="0"

DEPEND="test? ( >=sci-mathematics/sage-9.7 )"
RDEPEND=""
BDEPEND=""

RESTRICT="!test? ( test )"
