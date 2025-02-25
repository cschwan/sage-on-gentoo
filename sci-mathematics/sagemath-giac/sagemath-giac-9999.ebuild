# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sagemath/sagemath-giac.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x64-macos"
fi

DESCRIPTION="Support using Giac in sagemath"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2+"
SLOT="0"

#RESTRICT="test"

DEPEND="~sci-mathematics/sagemath-standard-${PV}[${PYTHON_USEDEP}]
	sci-mathematics/giac"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
