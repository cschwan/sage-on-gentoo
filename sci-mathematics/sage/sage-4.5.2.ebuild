# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit distutils eutils flag-o-matic python

MY_P="sage-${PV}"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples latex testsuite X"

# TODO: is cython RDEPEND ?
# TODO: there is only a test file which imports rpy: stats/test.py
# TODO: check if use flags are necessary
DEPEND="|| ( =dev-lang/python-2.6.4-r99
	=dev-lang/python-2.6.5-r99 )
	dev-libs/gmp
	>=dev-libs/mpfr-2.4.2
	>=dev-libs/ntl-5.5.2
	>=dev-lisp/ecls-10.2.1[-unicode]
	=dev-python/cython-0.12*
	~dev-python/numpy-1.3.0[lapack]
	>=sci-mathematics/eclib-20080310_p10
	>=sci-mathematics/ecm-6.2.1
	>=sci-libs/flint-1.5.0[ntl]
	>=sci-libs/fplll-3.0.12
	=sci-libs/givaro-3.2*
	>=sci-libs/gsl-1.10
	>=sci-libs/iml-1.0.1
	>=sci-libs/libcliquer-1.2.5
	>=sci-libs/linbox-1.1.6[ntl,sage]
	>=sci-libs/m4ri-20100221
	>=sci-libs/mpfi-1.4
	>=sci-libs/pynac-0.2.0_p4
	>=sci-libs/symmetrica-2.0
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/glpk-4.43[gmp]
	>=sci-mathematics/lcalc-1.23[pari]
	>=sci-mathematics/pari-2.3.5[data,gmp]
	>=sci-mathematics/polybori-0.6.4[sage]
	>=sci-mathematics/ratpoints-2.1.3
	~sci-mathematics/sage-baselayout-${PV}[testsuite=]
	~sci-mathematics/sage-clib-${PV}
	!!sci-mathematics/sage-core
	~sci-mathematics/singular-3.1.1.4[libsingular,sage]
	media-libs/gd
	media-libs/libpng
	>=sys-libs/readline-6.0
	sys-libs/zlib
	virtual/cblas"

RDEPEND="${CDEPEND}
	>=dev-lang/R-2.10.1[lapack,readline]
	>=dev-python/cvxopt-0.9
	>=dev-python/gdmodule-0.56
	>=dev-python/ipython-0.9.1
	>=dev-python/jinja-2.1.1
	>=dev-python/matplotlib-0.99.3
	~dev-python/mpmath-0.15
	~dev-python/networkx-1.0.1
	~dev-python/pexpect-2.0
	>=dev-python/pycrypto-2.0.1
	>=dev-python/python-gnutls-1.1.4
	>=dev-python/rpy-2.0.6
	>=dev-python/sphinx-0.6.3
	~dev-python/sympy-0.6.6
	>=media-gfx/tachyon-0.98
	>=net-zope/zodb-3.7.0
	>=sci-libs/cddlib-094f
	=sci-libs/scipy-0.7*
	>=sci-mathematics/flintqs-20070817_p4
	>=sci-mathematics/gap-4.4.12
	>=sci-mathematics/gap-guava-3.4
	>=sci-mathematics/genus2reduction-0.3
	>=sci-mathematics/gfan-0.4
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912_p12
	~sci-mathematics/maxima-5.20.1[ecl]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-1.1
	~sci-mathematics/sage-data-conway_polynomials-0.2
	~sci-mathematics/sage-data-elliptic_curves-0.1
	~sci-mathematics/sage-data-graphs-20070722_p1
	~sci-mathematics/sage-data-polytopes_db-20100210
	sci-mathematics/sage-doc
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/sage-notebook-0.8.1
	>=sci-mathematics/sympow-1.018
	examples? ( ~sci-mathematics/sage-examples-${PV} )
	latex? ( ~sci-mathematics/sage-latex-2.2.5 )
	testsuite? (
		~sci-mathematics/sage-examples-${PV}
	)"

# TODO: add:
# 		~sci-mathematics/sage-doc-${PV}[html]

# TODO: Are these DEPS ? :
# - >=sci-libs/factory-3.1.1

# Removed DEPS:
# - >=dev-python/imaging-1.1.6
# - dev-python/sqlalchemy[sqlite]
# - java? ( >=virtual/jre-1.6 )"
# - >=app-arch/bzip2-1.0.5
# -

src_prepare() {
	# ATLAS independence
	local cblaslibs=\'$(pkg-config --libs-only-l cblas | sed \
		-e 's/^-l//' \
		-e "s/ -l/\',\'/g" \
		-e 's/,.pthread//g' \
		-e "s:  ::")\'

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# Fix startup issue and python-2.6.5 problem
	append-flags -fno-strict-aliasing -DNDEBUG

	# fix build file to make it compile without other Sage components
	epatch "${FILESDIR}"/${PN}-4.3.4-site-packages.patch

	# add pari and gmp to everything.
	sed -i "s:\['stdc++', 'ntl'\]:\['stdc++', 'ntl','pari','gmp'\]:g" setup.py \
		|| die "failed to add pari and gmp everywhere"

	# remove annoying std=c99 from a c++ file.
	epatch "${FILESDIR}"/${PN}-4.4.4-extra-stdc99.patch

	# use already installed csage
	rm -rf c_lib || die "failed to remove c library directory"

	# patch SAGE_LOCAL
	sed -i "s:SAGE_LOCAL = SAGE_ROOT + '/local/':SAGE_LOCAL = os.environ['SAGE_LOCAL']:g" \
		module_list.py setup.py || die "failed to patch SAGE_LOCAL"

	# fix include paths
	sed -i \
		-e "s:SAGE_ROOT[[:space:]]*+[[:space:]]*\([\'\"]\)/local/include/\([^\1]*\)\1:SAGE_LOCAL + \1/include/\2\1:g" \
		-e "s:sage/c_lib/include/:${EPREFIX}/usr/include/csage/:g" \
		module_list.py || die "failed to patch paths for libraries"

	sed -i "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py || die "failed to patch extensions path"

	# fix png library name
	sed -i "s:png12:$(libpng-config --libs | cut -dl -f2):g" \
		module_list.py || die "failed to patch png library name"

	# fix numpy path
	sed -i "s:SAGE_ROOT+'/local/lib/python/site-packages/numpy/core/include':'$(python_get_sitedir)/numpy/core/include':g" \
		module_list.py || die "failed to patch path for numpy include directory"

	# fix cython path
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'$(python_get_sitedir)/Cython/Includes/':g" \
		setup.py || die "failed to patch path for cython include directory"

	# fix lcalc path
	sed -i "s:include/lcalc/:include/Lfunction/:g" module_list.py \
		|| die "failed to patch path for lcalc include directory"

	# rebuild in place
	sed -i "s:SAGE_DEVEL + 'sage/sage/ext/interpreters':'sage/ext/interpreters':g" \
		setup.py || die "failed to patch interpreters path"

	# fix include paths and CBLAS/ATLAS
	sed -i \
		-e "s:'%s/include/csage'%SAGE_LOCAL:'${EPREFIX}/usr/include/csage':g" \
		-e "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py || die "failed to patch include paths"

	sed -i \
		-e "s:BLAS, BLAS2:${cblaslibs}:g" \
		-e "s:,BLAS:,${cblaslibs}:g" \
		module_list.py || die "failed to patch module_list.py for ATLAS"

	# enable glpk
	sed -i "s:is_package_installed('glpk'):True:g" module_list.py \
		|| die "failed to enable glpk"

	# TODO: why does Sage fail with linbox commentator ?

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# gmp-5 compatibility - works with gmp-4.3 as well
	sed -i "s:__GMP_BITS_PER_MP_LIMB:GMP_LIMB_BITS:g" sage/rings/integer.pyx \
		|| die "failed to patch for gmp-5"

	# run maxima with ecl
	sed -i \
		-e "s:maxima-noreadline:maxima -l ecl:g" \
		-e "s:maxima --very-quiet:maxima -l ecl --very-quiet:g" \
		sage/interfaces/maxima.py || die "failed to patch maxima commands"

	# make use of singular-3.1.1.4 from the system
	epatch "${FILESDIR}"/${PN}-4.5.2-upgrade-singular.patch

	# use delaunay from matplotlib (see ticket #6946)
	epatch "${FILESDIR}"/${PN}-4.3.3-delaunay-from-matplotlib.patch

	# use arpack from scipy (see also scipy ticket #231)
	epatch "${FILESDIR}"/${PN}-4.3.3-arpack-from-scipy.patch

	# Adopt Ticket #8316 to replace jinja-1 with jinja-2
	epatch "${FILESDIR}"/${PN}-4.4.2-jinja2.patch

	# Fix portage QA warning. Potentially prevent some leaking.
	epatch "${FILESDIR}"/${PN}-4.4.2-flint.patch

	sed -i "s:cblas(), atlas():${cblaslibs}:" sage/misc/cython.py \
		|| die "failed to patch cython.py for ATLAS"

	# patch for optional glpk
	sed -i "s:\.\./\.\./local/include/glpk\.h:${EPREFIX}/usr/include/glpk.h:g" \
		sage/numerical/mip_glpk.pxd || die "failed to patch mip_glpk.pxd"

	sed -i "s:\.\./\.\./\.\./\.\./devel/sage/sage:..:g" \
		sage/numerical/mip_glpk.pyx || die "failed to patch mip_glpk.pyx"

	# Ticket #5155:

	# save gap_stamp to directory where sage is able to write
	sed -i "s:GAP_STAMP = '%s/local/bin/gap_stamp'%SAGE_ROOT:GAP_STAMP = '%s/gap_stamp'%DOT_SAGE:g" \
		sage/interfaces/gap.py || die "patch to patch gap interface"

	# fix qepcad paths
	epatch "${FILESDIR}"/${PN}-4.5.1-fix-qepcad-path.patch

	# fix save path (for testing only)
	sed -i "s:save(w,'test'):save(w,tmp_filename()):g" \
		sage/combinat/words/morphism.py || die "failed to patch path for save"

	# make sure line endings are unix ones so as not to confuse python-2.6.5
	edos2unix sage/libs/mpmath/ext_impl.pxd
	edos2unix sage/libs/mpmath/ext_main.pyx
	edos2unix sage/libs/mpmath/ext_main.pxd
	edos2unix sage/libs/mpmath/ext_libmp.pyx

	# replace SAGE_ROOT/local with SAGE_LOCAL
	epatch "${FILESDIR}"/${PN}-4.5.1-fix-SAGE_LOCAL.patch

	# do not forget to run distutils
	distutils_src_prepare
}

src_configure() {
	export SAGE_LOCAL="${EPREFIX}"/usr
	export SAGE_ROOT="${EPREFIX}"/usr/share/sage
	export SAGE_VERSION=${PV}

	export MAKE=${MAKEOPTS}

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

src_install() {
	if use testsuite ; then
		# TODO: install sources only ?
		insinto "${EPREFIX}${SAGE_ROOT}"/devel/sage-main
		doins -r sage || die
	fi

	distutils_src_install
}
