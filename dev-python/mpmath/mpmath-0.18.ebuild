# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1 eutils # virtualx

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="https://github.com/fredrik-johansson/mpmath http://pypi.python.org/pypi/mpmath/"
SRC_URI="http://sage.math.washington.edu/home/fredrik/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc examples gmp matplotlib test"

RDEPEND="
	gmp? ( dev-python/gmpy )
	matplotlib? ( dev-python/matplotlib )"
DEPEND="${RDEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}.patch"
		)

	# this fails with the current version of dev-python/py
	rm -f ${PN}/conftest.py || die

	# this test requires X
	rm -f ${PN}/tests/test_visualization.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		cd doc || die
		"${PYTHON}" build.py || die "Generation of documentation failed"
	fi
}

#src_test() {
#	local DISTUTILS_NO_PARALLEL_BUILD=true
#	VIRTUALX_COMMAND="distutils-r1_src_test"
#	virtualmake
#}

python_test() {
	py.test -v || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/. )

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins demo/*
	fi
	distutils-r1_python_install_all
}

python_install() {
	distutils-r1_python_install
	local path="${ED}$(python_get_sitedir)/${PN}/libmp/"
	if [[ "${EPYTHON}" != python2* ]]; then
		rm -f "${path}exec_py2.py" || ide
	elif [[ "${EPYTHON}" != python3 ]]; then
		rm -f "${path}exec_py3.py" || die
	fi
}
