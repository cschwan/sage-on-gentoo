# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Matrices over small finite fields with meataxe in sage"
HOMEPAGE="https://www.sagemath.org"
KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2+"
SLOT="0"

# No real tests here in spite of QA warnings.
RESTRICT="test mirror"

# pplpy needs to be installed to get documentation folder right :(
DEPEND="~sci-mathematics/sage-${PV}[${PYTHON_USEDEP}]
	sci-mathematics/shared_meataxe"
BDEPEND=""
RDEPEND="${DEPEND}"
