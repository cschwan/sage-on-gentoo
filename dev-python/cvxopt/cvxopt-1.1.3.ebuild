# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND=2:2.5
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.4 3.*"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES=1

inherit eutils distutils python

DESCRIPTION="A Python Package for Convex Optimization"
HOMEPAGE="http://abel.ee.ucla.edu/cvxopt"
SRC_URI="http://abel.ee.ucla.edu/${PN}/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fftw glpk gsl"

DEPEND="virtual/blas
	virtual/lapack
	virtual/cblas
	fftw? ( sci-libs/fftw )
	glpk? ( sci-mathematics/glpk )
	gsl? ( sci-libs/gsl )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/src

src_prepare(){
	epatch "${FILESDIR}/${PN}"-1.1.3-blas.patch

	BLAS=\'$(pkg-config --libs-only-l blas | sed \
		-e 's/^-l//' \
		-e "s/ -l/\',\'/g" \
		-e 's/.,.pthread//g' \
		-e "s:  ::")\'
	LAPACK=\'$(pkg-config --libs-only-l lapack | sed \
		-e 's/^-l//' \
		-e "s/ -l/\',\'/g" \
		-e 's/.,.pthread//g' \
		-e "s:  ::")\'

	sed -i \
		-e "s:@GENTOO_BLAS:${BLAS}:" \
		-e "s:@GENTOO_LAPACK:${LAPACK}:" \
		setup.py

	distutils_src_prepare

	prepare_builddir() {
		set_flag() {
			if use ${1}; then
				sed -i -e "s/\(BUILD_${2} =\) 0/\1 1/" setup.py || die
			fi
		}

		set_flag gsl GSL
		set_flag fftw FFTW
		set_flag glpk GLPK
	}
	python_execute_function -s prepare_builddir
}
