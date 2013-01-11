# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sympy/sympy-0.7.2.ebuild,v 1.1 2012/10/20 18:17:24 grozin Exp $

EAPI="3"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython *-pypy-*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

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
	ipython? ( dev-python/ipython )
	opengl? ( dev-python/pyopengl )
	imaging? ( dev-python/imaging )
	pyglet? ( dev-python/pyglet )
	>=dev-python/pexpect-2.0
	~dev-python/mpmath-0.17"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest )"

pkg_setup() {
	python_pkg_setup
	export DOT_SAGE="${S}"
}

src_prepare() {
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
}

src_compile() {
	PYTHONPATH="." distutils_src_compile

	if use doc; then
		cd doc
		emake html || die "emake html failed"
	fi
}

src_install() {
	PYTHONPATH="." distutils_src_install

	rm -f "${ED}usr/bin/"{doctest,test} || die "rm doctest test failed"

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
