# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.4 2.5 *-jython 2.7-pypy-*"

inherit distutils eutils

DESCRIPTION="Python package for convex optimization"
HOMEPAGE="http://abel.ee.ucla.edu/cvxopt"
SRC_URI="http://abel.ee.ucla.edu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +dsdp examples fftw +glpk gsl"

RDEPEND="virtual/blas
	virtual/cblas
	virtual/lapack
	sci-libs/cholmod
	sci-libs/umfpack
	dsdp? ( sci-libs/dsdp )
	fftw? ( sci-libs/fftw:3.0 )
	glpk? ( sci-mathematics/glpk )
	gsl? ( sci-libs/gsl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

S="${WORKDIR}/${P}/src"

src_prepare(){
	epatch "${FILESDIR}"/${P}-setup.patch
	rm -rf src/C/SuiteSparse*/
	rm -rf ../doc/build # 413905

	pkg_lib() {
		local pylib=\'$(pkg-config --libs-only-l ${1} | sed \
			-e 's/^-l//' \
			-e "s/ -l/\',\'/g" \
			-e 's/.,.pthread//g' \
			-e "s: ::g")\'
		sed -i -e "/_LIB = /s:\(.*\)'${1}'\(.*\):\1${pylib}\2:" setup.py
	}

	use_cvx() {
		if use ${1}; then
			sed -i \
				-e "s/\(BUILD_${1^^} =\) 0/\1 1/" \
				setup.py || die
		fi
	}

	pkg_lib blas
	pkg_lib lapack
	use_cvx gsl
	use_cvx fftw
	use_cvx glpk
	use_cvx dsdp
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	use doc && emake -C "${WORKDIR}"/${P}/doc -B html
}

src_test() {
	cd "${WORKDIR}"/${P}/examples/doc/chap8
	testing() {
		PYTHONPATH="$(ls -d ${S}/build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" lp.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	use doc && dohtml -r "${WORKDIR}"/${P}/doc/build/html/*
	insinto /usr/share/doc/${PF}
	use examples && doins -r "${WORKDIR}"/${P}/examples
}
