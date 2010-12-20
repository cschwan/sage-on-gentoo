# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.5"

inherit eutils distutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples gtk imaging ipython latex mathml opengl pdf png test texmacs"

RDEPEND="mathml? ( dev-libs/libxml2[python]
		dev-libs/libxslt[python]
		gtk? ( x11-libs/gtkmathview[gtk] ) )
	latex? ( virtual/latex-base
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl ) )
	texmacs? ( app-office/texmacs )
	ipython? ( dev-python/ipython )
	opengl? ( dev-python/pyopengl )
	imaging? ( dev-python/imaging )
	>=dev-python/pexpect-2.0"
DEPEND="doc? ( dev-python/sphinx )
	test? ( >=dev-python/py-0.9.0 )"

pkg_setup() {
	export DOT_SAGE="${S}"
}

src_prepare() {
	distutils_src_prepare

	# remove sage's test as it is broken:
	# http://code.google.com/p/sympy/issues/detail?id=1866&q=test_sage
	rm sympy/test_external/test_sage.py

	# use local sphinx
	epatch "${FILESDIR}"/${P}-sphinx.patch
}

src_compile() {
	PYTHONPATH="." distutils_src_compile

	if use doc; then
		cd doc
		PYTHONPATH=.. emake SPHINXBUILD=sphinx-build html \
			|| die "emake html failed"
		cd ..
	fi
}

src_test() {
	PYTHONPATH=build/lib/ "${python}" setup.py test || die "Unit tests failed!"
}

src_install() {
	PYTHONPATH="." distutils_src_install

	rm "${ED}"/usr/bin/test "${ED}"/usr/bin/doctest \
		|| die "rm  test doctest failed"

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
