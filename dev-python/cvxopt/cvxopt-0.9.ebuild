# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.5"
PYTHON_MODNAME="cvxopt"

inherit distutils

DESCRIPTION="A Python Package for Convex Optimization"
HOMEPAGE="http://abel.ee.ucla.edu/cvxopt"
SRC_URI="http://abel.ee.ucla.edu/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fftw glpk gsl"

RESTRICT="mirror"

DEPEND="virtual/blas
	virtual/cblas
	virtual/lapack
	fftw? ( sci-libs/fftw )
	glpk? ( sci-mathematics/glpk )
	gsl? ( sci-libs/gsl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}/src

src_prepare() {
	sed -i "s:g2c:gfortran:g" setup.py || die "sed failed"

	if use gsl ; then
		sed -i "s:BUILD_GSL = 0:BUILD_GSL = 1:" setup.py || die "sed failed"
	fi

	if use fftw ; then
		sed -i "s:BUILD_FFTW = 0:BUILD_FFTW = 1:" setup.py || die "sed failed"
	fi

	if use glpk ; then
		sed -i "s:BUILD_GLPK = 0:BUILD_GLPK = 1:" setup.py || die "sed failed"
	fi
}
