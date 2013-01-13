# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 eutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc examples gtk imaging ipython latex mathml opengl pdf png pyglet test texmacs"

RDEPEND="
	mathml? (
		dev-libs/libxml2:2[python,${PYTHON_USEDEP}]
		dev-libs/libxslt[python,${PYTHON_USEDEP}]
		gtk? ( x11-libs/gtkmathview[gtk] ) )
	latex? (
		virtual/latex-base
		dev-texlive/texlive-fontsextra
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl ) )
	texmacs? ( app-office/texmacs )
	ipython? ( dev-python/ipython )
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	imaging? ( dev-python/imaging )
	pyglet? ( dev-python/pyglet )
	>=dev-python/pexpect-2.0[${PYTHON_USEDEP}]
	~dev-python/mpmath-0.17"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

pkg_setup() {
	export DOT_SAGE="${S}"
}

python_prepare_all() {
	# Remove mpmath
	rm -rf sympy/mpmath/*
	sed -i \
		-e "s:from sympy import mpmath:import mpmath:g" \
			sympy/core/function.py \
			sympy/core/tests/test_sympify.py \
			sympy/core/tests/test_numbers.py \
			sympy/core/power.py \
			sympy/external/tests/test_numpy.py \
			sympy/utilities/tests/test_lambdify.py \
			sympy/utilities/decorator.py

	sed -i \
		-e "s:sympy\.mpmath:mpmath:g" \
		sympy/combinatorics/permutations.py \
		sympy/core/evalf.py \
		sympy/core/expr.py \
		sympy/core/function.py \
		sympy/core/numbers.py \
		sympy/core/sets.py \
		sympy/core/tests/test_evalf.py \
		sympy/core/tests/test_numbers.py \
		sympy/core/tests/test_sets.py \
		sympy/functions/combinatorial/numbers.py \
		sympy/functions/special/bessel.py \
		sympy/functions/special/gamma_functions.py \
		sympy/matrices/matrices.py \
		sympy/ntheory/partitions_.py \
		sympy/physics/quantum/constants.py \
		sympy/physics/quantum/qubit.py \
		sympy/polys/domains/groundtypes.py \
		sympy/polys/numberfields.py \
		sympy/polys/polytools.py \
		sympy/polys/rootoftools.py \
		sympy/printing/latex.py \
		sympy/printing/repr.py \
		sympy/printing/str.py \
		sympy/simplify/simplify.py \
		sympy/solvers/solvers.py \
		sympy/solvers/tests/test_numeric.py \
		sympy/statistics/distributions.py \
		sympy/statistics/tests/test_statistics.py \
		sympy/utilities/lambdify.py \
		examples/advanced/pidigits.py \
		examples/advanced/autowrap_ufuncify.py \
		|| die "failed to patch mpmath imports"
	epatch "${FILESDIR}"/${P}-mpmath.patch
	epatch "${FILESDIR}"/${P}-mpmath-import.patch
	epatch "${FILESDIR}"/${P}-mpmath-test.patch

	distutils-r1_python_prepare_all
}

python_compile() {
	PYTHONPATH="." distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		cd doc
		emake html || die "emake html failed"
	fi
}

python_install() {
	PYTHONPATH="." distutils-r1_python_install

	rm -f "${ED}usr/bin/"{doctest,test} || die "rm doctest test failed"
}

python_install_all() {
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
