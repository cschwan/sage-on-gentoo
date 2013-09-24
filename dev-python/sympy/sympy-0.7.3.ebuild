# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7,3_2} )

inherit distutils-r1 eutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://sympy.org/"
SRC_URI="python_targets_python2_6? ( https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz )
	python_targets_python2_7? ( https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz )
	python_targets_python3_2? ( https://github.com/${PN}/${PN}/releases/download/${P}/${P}-py3.2.tar.gz )"
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

S="${WORKDIR}"

src_unpack() {
	if use python_targets_python2_6 || use python_targets_python2_7; then
		mkdir "${WORKDIR}"/python2
		cd "${WORKDIR}"/python2
		unpack ${P}.tar.gz
	fi
	if use python_targets_python3_2; then
		mkdir "${WORKDIR}"/python3
		cd "${WORKDIR}"/python3
		unpack ${P}-py3.2.tar.gz
	fi
}

src_prepare() {
	if use python_targets_python2_6 || use python_targets_python2_7; then
		cd "${WORKDIR}"/python2/${P}
		epatch "${FILESDIR}"/${P}-mpmathtest.patch
		rm sympy/mpmath/libmp/exec_py3.py
	fi
	if use python_targets_python3_2; then
		cd "${WORKDIR}"/python3/${P}
		epatch "${FILESDIR}"/${P}-mpmathtest.patch
		rm sympy/mpmath/libmp/exec_py2.py
	fi
}

python_compile() {
	case ${EPYTHON} in
		python2*) cd "${WORKDIR}"/python2/${P};;
		python3*) cd "${WORKDIR}"/python3/${P};;
	esac
	PYTHONPATH="." distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		if use python_targets_python2_6 || use python_targets_python2_7; then
			cd "${WORKDIR}"/python2/${P}/doc
			emake html
		else
			cd "${WORKDIR}"/python3/${P}/doc
			emake html
		fi
	fi
}

python_test() {
	case ${EPYTHON} in
		python2*) cd "${WORKDIR}"/python2/${P};;
		python3*) cd "${WORKDIR}"/python3/${P};;
	esac
	PYTHONPATH="." py.test || ewarn "tests with ${EPYTHON} failed"
}

python_install() {
	case ${EPYTHON} in
		python2*) cd "${WORKDIR}"/python2/${P};;
		python3*) cd "${WORKDIR}"/python3/${P};;
	esac
	PYTHONPATH="." distutils-r1_python_install
}

python_install_all() {
	if use python_targets_python2_6 || use python_targets_python2_7; then
		cd "${WORKDIR}"/python2/${P}
		distutils-r1_python_install_all
	else
		cd "${WORKDIR}"/python3/${P}
		distutils-r1_python_install_all
	fi
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
