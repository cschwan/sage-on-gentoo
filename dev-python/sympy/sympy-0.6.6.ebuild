# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2
NEED_PYTHON=2.4
inherit eutils distutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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
	|| ( dev-python/ctypes >=dev-lang/python-2.5 )
	>=dev-python/pexpect-2.0"
DEPEND="doc? ( dev-python/sphinx )
	test? ( >=dev-python/py-0.9.0 )"

src_prepare() {
	distutils_src_prepare

	# use local sphinx
	epatch "${FILESDIR}"/${P}-sphinx.patch
}

src_compile() {
	distutils_src_compile

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
	distutils_src_install

	rm "${D}"/usr/bin/test "${D}"/usr/bin/doctest || die "rm  test doctest failed"

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
