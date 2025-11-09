# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python

inherit distutils-r1

MY_PN="sagemath_giac"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sagemath/sagemath-giac.git"
else
	KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x64-macos"
	SRC_URI="https://github.com/sagemath/${PN}/releases/download/${PV}/${MY_PN}-${PV}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Support using Giac in sagemath"
HOMEPAGE="https://github.com/sagemath/sagemath-giac"

LICENSE="GPL-2+"
SLOT="0"

DEPEND=">=sci-mathematics/sagemath-10.7[${PYTHON_USEDEP}]
	sci-mathematics/giac"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
