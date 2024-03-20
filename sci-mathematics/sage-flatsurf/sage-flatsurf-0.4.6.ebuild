# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="package for working with flat surfaces in SageMath."
HOMEPAGE="https://github.com/flatsurf/sage-flatsurf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sagemath-standard-9.7[${PYTHON_USEDEP}]
	sci-mathematics/surface-dynamics[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/152.patch
	)

python_test(){
	sage -t --long flatsurf || die "test failed"
}
