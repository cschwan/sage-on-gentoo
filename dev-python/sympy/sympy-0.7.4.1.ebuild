# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7,3_2} )

inherit distutils-r1 eutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://sympy.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc examples gtk imaging ipython latex mathml opengl pdf png pyglet test texmacs"

RDEPEND="
	mathml? (
		dev-libs/libxml2:2[python]
		dev-libs/libxslt[python]
		gtk? ( x11-libs/gtkmathview[gtk] ) )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl ) )
	texmacs? ( app-office/texmacs )
	ipython? ( dev-python/ipython[${PYTHON_USEDEP}] )
	opengl? ( dev-python/pyopengl[python_targets_python2_6?,python_targets_python2_7?] )
	imaging? ( virtual/python-imaging[${PYTHON_USEDEP}] )
	pyglet? ( dev-python/pyglet[python_targets_python2_6?,python_targets_python2_7?] )
	>=dev-python/pexpect-2.0[python_targets_python2_6?,python_targets_python2_7?]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-0.7.3-mpmathtest.patch )

python_prepare() {
	case ${EPYTHON} in
		python2*) rm sympy/mpmath/libmp/exec_py3.py;;
		python3*) rm sympy/mpmath/libmp/exec_py2.py;;
	esac
}

python_compile() {
	PYTHONPATH="." distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		pushd doc
		emake html
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	PYTHONPATH="." py.test || ewarn "tests with ${EPYTHON} failed"
}

python_install() {
	PYTHONPATH="." distutils-r1_python_install
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dohtml -r doc/_build/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples
	fi

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}
