# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3 sage-git
	SAGE_PKG="sage-docbuild"
else
	inherit pypi
	KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

DESCRIPTION="Tool to build doc for sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2"
SLOT="0"

RESTRICT="mirror test"

RDEPEND="
	>=dev-python/sphinx-7.2.0[${PYTHON_USEDEP}]
	dev-python/jupyter-sphinx[${PYTHON_USEDEP}]
"
PDEPEND="~sci-mathematics/sagemath-standard-${PV}[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/sage-9.3-linguas.patch
)
