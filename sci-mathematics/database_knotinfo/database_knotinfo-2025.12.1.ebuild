# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Content of the KnotInfo & LinkInfo databases as lists of dictionaries"
HOMEPAGE="https://pypi.org/project/database-knotinfo/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x64-macos"
IUSE="test"

DEPEND="test? ( >=sci-mathematics/sagemath-10.8 )"

RESTRICT="!test? ( test )"
