# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="A Python interface to the number theory library libpari"
HOMEPAGE="https://github.com/sagemath/cypari2"
SRC_URI="https://github.com/sagemath/${PN}/releases/download/${PV}/${P}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/pari-2.13:=[gmp,doc]
	dev-python/cysignals[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/0001-move-rebuild-out-of-build_ext-so-it-is-run-before-ev.patch
)

python_test(){
	cd "${S}"/tests
	${EPYTHON} rundoctest.py
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
