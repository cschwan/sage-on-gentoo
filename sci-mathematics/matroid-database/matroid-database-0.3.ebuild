# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=NO

inherit distutils-r1 pypi

DESCRIPTION="Yoshitake Matsumoto, Database of Matroids"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
HOMEPAGE="https://pypi.org/project/matroid-database/"
IUSE="test"

LICENSE="GPL-3"
SLOT="0"

DEPEND="test? ( >=sci-mathematics/sagemath-standard-10.3 )"

RESTRICT="!test? ( test )"
