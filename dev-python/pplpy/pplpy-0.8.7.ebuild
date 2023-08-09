# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A Python wrapper for the Parma Polyhedra Library (PPL)"
HOMEPAGE="https://github.com/sagemath/pplpy"

LICENSE="GPL-3"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-python/gmpy-2.1.0[${PYTHON_USEDEP}]
	dev-python/cysignals[${PYTHON_USEDEP}]
	>=dev-libs/ppl-1.2
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/cython-3.0.0"

python_compile() {
	# automatic parallel building with python3.5+ is not safe
	distutils-r1_python_compile -j 1
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all(){
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}

python_test(){
	"${EPYTHON}" setup.py test
}
