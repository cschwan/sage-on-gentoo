# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib python sage flag-o-matic

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wiki"

# TODO: check dependencies use flagged packages
CDEPEND=">=app-arch/bzip2-1.0.5
	=dev-lang/python-2.6.4-r99[sqlite]
	>=dev-lang/R-2.10.1[lapack,readline]
	>=dev-libs/mpfr-2.4.2
	>=dev-libs/ntl-5.5.2
	>=dev-python/cython-0.12.1
	>=dev-python/gdmodule-0.56
	>=dev-python/ipython-0.9.1
	>=dev-python/jinja-1.2
	>=dev-python/numpy-1.3.0[lapack]
	>=dev-python/rpy-2.0.6
	>=dev-python/matplotlib-0.99.1
	>=dev-python/mpmath-0.14
	~dev-python/pexpect-2.0
	>=dev-python/pycrypto-2.0.1
	>=dev-python/python-gnutls-1.1.4
	>=dev-python/sympy-0.6.4
	>=dev-python/networkx-1.0.1
	>=net-zope/zodb-3.7.0
	>=net-zope/zope-i18nmessageid-3.5.0
	>=net-zope/zope-testbrowser-3.7.0
	>=sci-libs/flint-1.5.0[ntl]
	>=sci-libs/fplll-3.0.12
	>=sci-libs/ghmm-0.9_rc1[lapack,python]
	=sci-libs/givaro-3.2*
	>=sci-libs/gsl-1.10
	>=sci-libs/iml-1.0.1
	>=sci-libs/lapack-atlas-3.8.3
	>=sci-libs/libcliquer-1.2.5
	>=sci-libs/linbox-1.1.6[ntl,sage]
	>=sci-libs/m4ri-20091120
	>=sci-libs/mpfi-1.3.4
	>=sci-libs/mpir-1.2.2[cxx]
	>=sci-libs/pynac-0.1.10
	>=sys-libs/readline-6.0
	>=sci-libs/symmetrica-2.0
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/eclib-20080310_p10
	>=sci-mathematics/ecm-6.2.1
	|| ( >=sci-mathematics/pari-2.3.3[data,gmp]
	     >=sci-mathematics/pari-2.3.3[data,mpir] )
	>=sci-mathematics/polybori-0.6.4[sage]
	>=sci-mathematics/ratpoints-2.1.3
	>=sci-mathematics/rubiks-20070912_p10
	~sci-mathematics/sage-clib-${PV}
	~sci-mathematics/sage-core-${PV}
	~sci-mathematics/sage-data-${PV}
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/sage-notebook-0.7.5.3
	~sci-mathematics/sage-singular-3.1.0.4.20100214
	virtual/cblas"

DEPEND="${CDEPEND}
	>=dev-python/setuptools-0.6.9
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	>=dev-python/imaging-1.1.6
	sci-mathematics/sage-doc
	~sci-mathematics/sage-examples-${PV}
	~sci-mathematics/sage-latex-2.2.3
	>=sci-mathematics/gap-4.4.12
	>=sci-mathematics/gap-guava-3.4
	>=sci-mathematics/maxima-5.20.1[ecl]
	>=sci-mathematics/genus2reduction-0.3
	>=sci-mathematics/lcalc-1.23[pari]
	>=sci-mathematics/sympow-1.018
	>=sci-libs/cddlib-094f
	>=sci-mathematics/gfan-0.4
	>=media-gfx/tachyon-0.98
	>=sci-mathematics/flintqs-20070817_p4
	>=sci-mathematics/palp-1.1
	>=sci-libs/scipy-0.7
	>=dev-python/cvxopt-0.9
	dev-python/sqlalchemy[sqlite]
	>=dev-python/sphinx-0.6.3
	wiki? ( ~www-apps/sage-moin-1.9.1_p1 )"

src_install() {
	# install entries for desktop managers
	doicon "${FILESDIR}"/sage.svg || die "doicon failed"
	domenu "${FILESDIR}"/sage-shell.desktop || die "domenu failed"
}

pkg_postinst() {
	# make sure files are correctly setup in the new location by running sage
	# as root. This prevent nasty message to be presented to the user.
	"${SAGE_ROOT}"/sage -c
}
