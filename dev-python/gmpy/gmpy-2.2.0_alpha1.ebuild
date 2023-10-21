# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="gmpy2"
MY_PV="${PV:0:5}a1"
MY_P="${PYPI_PN}-${MY_PV}"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="
	https://github.com/aleaxit/gmpy/
	https://pypi.org/project/gmpy2/
"
SRC_URI="https://github.com/aleaxit/gmpy/archive/refs/tags/${MY_P}.tar.gz -> ${MY_P}.gh.tar.gz"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~m68k ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
"
RDEPEND="
	${DEPEND}
	dev-python/mpmath[${PYTHON_USEDEP}]
"

S="${WORKDIR}/gmpy-${MY_P}"

distutils_enable_sphinx docs

python_test() {
	cd test || die
	"${EPYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}
