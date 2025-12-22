# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="package for working with flat surfaces in SageMath."
HOMEPAGE="https://github.com/flatsurf/sage-flatsurf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sagemath-10.8[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sci-mathematics/surface-dynamics[${PYTHON_USEDEP}]"

RESTRICT="test"

python_test(){
	sage-runtests flatsurf || die "test failed"
}
