# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="readline,sqlite"

# disable parallel build - Sage has its own method (see src_configure)
DISTUTILS_NO_PARALLEL_BUILD="1"

inherit distutils-r1 eutils flag-o-matic multilib multiprocessing prefix toolchain-funcs versionator

MY_P="sage-$(replace_version_separator 2 '.')"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2
	mirror://sagemath/patches/${PN}-5.10-neutering-r3.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="latex testsuite lrs nauty debug"

RESTRICT="mirror test"

CDEPEND="dev-libs/gmp
	>=dev-libs/mpfr-3.1.0
	>=dev-libs/mpc-1.0
	>=dev-libs/ntl-5.5.2
	>=dev-libs/ppl-0.11.2
	>=dev-lisp/ecls-12.12.1-r5
	>=dev-python/numpy-1.7.0[${PYTHON_USEDEP}]
	~dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	~sci-mathematics/eclib-20120830
	>=sci-mathematics/gmp-ecm-6.4.4[-openmp]
	>=sci-mathematics/flint-2.3
	~sci-libs/fplll-3.0.12
	~sci-libs/givaro-3.7.1
	>=sci-libs/gsl-1.15
	>=sci-libs/iml-1.0.1
	>=sci-libs/libcliquer-1.21_p0
	>=sci-libs/libgap-4.5.7
	~sci-libs/linbox-1.3.2[sage]
	~sci-libs/m4ri-20130416
	~sci-libs/m4rie-20130416
	>=sci-libs/mpfi-1.5.1
	>=sci-libs/pynac-0.2.6[${PYTHON_USEDEP}]
	>=sci-libs/symmetrica-2.0
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/glpk-4.44
	>=sci-mathematics/lcalc-1.23-r4[pari]
	>=sci-mathematics/lrcalc-1.1.6_beta1
	>=sci-mathematics/pari-2.5.4[data,gmp]
	>=sci-mathematics/polybori-0.8.3
	>=sci-mathematics/ratpoints-2.1.3
	~sci-mathematics/sage-baselayout-${PV}[testsuite=,${PYTHON_USEDEP}]
	~sci-mathematics/sage-clib-${PV}
	>=sci-libs/libsingular-3.1.5-r2
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas"

DEPEND="${CDEPEND}
	!dev-python/gmpy"

RDEPEND="${CDEPEND}
	>=dev-lang/R-2.14.0
	>=dev-python/cvxopt-1.1.5[glpk,${PYTHON_USEDEP}]
	>=dev-python/gdmodule-0.56-r2[png]
	~dev-python/ipython-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.5.5[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/mpmath-0.17[${PYTHON_USEDEP}]
	~dev-python/networkx-1.6
	~dev-python/pexpect-2.0[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.0.8[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.5.8[${PYTHON_USEDEP}]
	>=dev-python/sympy-0.7.1[${PYTHON_USEDEP}]
	>=media-gfx/tachyon-0.98.9[png]
	>=sci-libs/cddlib-094f-r2
	>=sci-libs/scipy-0.11.0[${PYTHON_USEDEP}]
	>=sci-mathematics/flintqs-20070817_p8
	>=sci-mathematics/gap-4.5.7
	>=sci-mathematics/genus2reduction-0.3_p8-r1
	~sci-mathematics/gfan-0.5
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912_p18
	>=sci-mathematics/maxima-5.29.1-r2[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-elliptic_curves-0.7
	~sci-mathematics/sage-data-graphs-20120404_p4
	~sci-mathematics/sage-data-polytopes_db-20120220
	>=sci-mathematics/sage-doc-${PV}
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/singular-3.1.5
	>=sci-mathematics/sympow-1.018.1_p11
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
	testsuite? ( >=sci-mathematics/sage-doc-${PV}[html] )
	latex? (
		~dev-tex/sage-latex-2.3.3_p2
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)
	lrs? ( sci-libs/lrslib )
	nauty? ( sci-mathematics/nauty )"

PDEPEND="~sci-mathematics/sage-notebook-0.10.4[${PYTHON_USEDEP}]
	~sci-mathematics/sage-data-conway_polynomials-0.4"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

python_prepare() {
	# ATLAS independence
	local cblaslibs=\'$(pkg-config --libs-only-l cblas | sed \
		-e 's/^-l//' \
		-e "s/ -l/\',\'/g" \
		-e 's/.,.pthread//g' \
		-e "s: ::g")\'

	# Remove sage's package management system
	epatch "${WORKDIR}"/patches/${PN}-5.10-package.patch
	rm sage/misc/package.py

	# Remove sage's mercurial capabilities
	epatch "${WORKDIR}"/patches/${PN}-5.10-hg.patch
	rm sage/misc/hg.py

	# Remove sage cmdline tests related to these
	epatch "${WORKDIR}"/patches/${PN}-5.10-cmdline.patch

	if use lrs; then
		sed -i "s:if True:if False:" sage/geometry/polyhedron/base.py
	fi

	if use nauty; then
		sed -i "s:if True:if False:" \
			sage/graphs/graph_generators.py \
			sage/graphs/digraph_generators.py \
			sage/graphs/hypergraph_generators.py
	fi

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# Fix startup issue and python-2.6.5 problem
	append-flags -fno-strict-aliasing

	epatch "${FILESDIR}"/${PN}-4.7.2-site-packages.patch

	# use already installed csage
	rm -rf c_lib || die "failed to remove c library directory"

	# fix png library name
	sed -i "s:png12:$(libpng-config --libs | cut -dl -f2):g" module_list.py

	# fix numpy path (final quote removed to catch numpy_include_dirs and numpy_depends)
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/numpy/core/include:'$(python_get_sitedir)/numpy/core/include:g" \
		module_list.py

	# fix lcalc path
	sed -i "s:SAGE_INC + \"/libLfunction:SAGE_INC + \"/Lfunction:g" module_list.py

	# fix CBLAS/ATLAS
	sed -i \
		-e "s:BLAS, BLAS2:${cblaslibs}:g" \
		-e "s:,BLAS:,${cblaslibs}:g" \
		module_list.py

	# Add -DNDEBUG to objects linking to libsingular and use factory headers from singular.
	sed -i "s:, SAGE_INC + '/factory'::g" module_list.py
	# We add -DNDEBUG to objects linking to givaro. It solves problems with linbox and singular.
	sed -i "s:-D__STDC_LIMIT_MACROS:-D__STDC_LIMIT_MACROS', '-DNDEBUG:g" \
		module_list.py

	# flint patch resurected
	epatch "${FILESDIR}"/trac_14656.patch

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# sage on gentoo env.py
	epatch "${FILESDIR}"/sage-5.10-env.patch
	eprefixify sage/env.py

	# fix library path of libsingular
	sed -i "s:os.environ\['SAGE_LOCAL'\]+\"/lib:\"${EPREFIX}/usr/$(get_libdir):" \
		sage/libs/singular/singular.pyx

	# TODO: should be a patch
	# run maxima with ecl
	sed -i "s:'maxima :'maxima -l ecl :g" \
		sage/interfaces/maxima.py \
		sage/interfaces/maxima_abstract.py

	# speaking ecl - patching so we can allow ecl with unicode
	epatch "${FILESDIR}"/trac12985-unicode.patch

	# TODO: should be a patch
	# Uses singular internal copy of the factory header
	sed -i "s:factory/factory.h:singular/factory.h:" \
		sage/libs/singular/singular-cdefs.pxi

	sed -i "s:cblas(), atlas():${cblaslibs}:" sage/misc/cython.py

	# remove the need for the external "testjava.sh" script
	epatch "${FILESDIR}"/remove-testjavapath-to-python.patch

	# Make sage-inline-fortran useless by having better fortran settings
	sed -i \
		-e "s:--f77exec=sage-inline-fortran:--f77exec=$(tc-getF77):g" \
		-e "s:--f90exec=sage-inline-fortran:--f90exec=$(tc-getFC):g" \
		sage/misc/inline_fortran.py

	# TODO: should be a patch
	# patch lie library path
	sed -i -e "s:/lib/LiE/:/share/lie/:" sage/interfaces/lie.py

	# patching libs/gap/util.pyx so we don't get noise from missing SAGE_LOCAL/gap/latest
	epatch "${FILESDIR}"/${PN}-5.9-libgap.patch

	# TODO: should be a patch
	# Getting the singular documentation from the right place
	sed -i "s:os.environ\[\"SAGE_LOCAL\"\]+\"/share/singular/\":sage.env.SAGE_DOC + \"/\":" \
		sage/interfaces/singular.py

	# TODO: should be a patch + eprefixy
	# Get gprc.expect from the right place
	sed -i "s:SAGE_LOCAL, 'etc', 'gprc.expect':'${EPREFIX}/etc','gprc.expect':" \
		sage/interfaces/gp.py

	# allow sage-matroids to be used if installed
	epatch "${FILESDIR}"/${PN}-matroids.patch

	############################################################################
	# Fixes to doctests
	############################################################################

	# TODO: should be a patch
	# remove 'local' part
	sed -i "s:\.\.\./local/share/pari:.../share/pari:g" sage/interfaces/gp.py

	# fix all.py
	epatch "${FILESDIR}"/${PN}-5.9-all.py
	sed -i "s:\"lib\",\"python\":\"$(get_libdir)\",\"${EPYTHON}\":" sage/all.py

	# remove strings of libraries that we do not link to
	epatch "${FILESDIR}"/${PN}-5.8-fix-cython-doctest.patch

	# only do a very basic R version string test
	epatch "${FILESDIR}"/${PN}-5.8-fix-r-doctest.patch

	# do not test safe python stuff from trac 13579
	epatch "${FILESDIR}"/${PN}-5.9-safepython.patch

	# remove version information of GLPK
	epatch "${FILESDIR}"/${PN}-5.9-fix-mip-doctest.patch

	# 'sage' is not in SAGE_ROOT, but in PATH
	epatch "${FILESDIR}"/${PN}-5.9-fix-ostools-doctest.patch
}

python_configure() {
	export SAGE_LOCAL="${EPREFIX}"/usr/
	export SAGE_ROOT="${EPREFIX}"/usr/share/sage
	export SAGE_SRC=`pwd`
	export SAGE_VERSION=${PV}
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	if use debug; then
		export SAGE_DEBUG=1
	fi

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

python_install_all() {
	distutils-r1_python_install_all

	# install sources needed for testing/compiling of cython/spyx files
	find sage ! \( -name "*.py" -o -name "*.pyx" -o -name "*.pxd" -o \
		-name "*.pxi" -o -name "*.h" \
		-o -name "*matrix_rational_dense_linbox.cpp" \
		-o -name "*wrap.cc" \
		-o -name "*.rst" \) -type f -delete \
		|| die "failed to remove non-testable sources"

	insinto /usr/share/sage/devel/sage-main
	doins -r sage
	if use debug; then
		cd build
		doins -r cython_debug
	fi
}

pkg_postinst() {
	einfo "If you use Sage's browser interface ('Sage Notebook') and experience"
	einfo "an 'Internal Server Error' you should append the following line to"
	einfo "your ~/.bashrc (replace firefox with your favorite browser and note"
	einfo "that in your case it WILL NOT WORK with xdg-open):"
	einfo ""
	einfo "  export SAGE_BROWSER=/usr/bin/firefox"
	einfo ""

	einfo "Vanilla Sage comes with the 'Standard' set of Sage Packages, i.e."
	einfo "those listed at: http://sagemath.org/packages/standard/ which are"
	einfo "installed now."
	einfo "There are also some packages of the 'Optional' set (which consists"
	einfo "of the these: http://sagemath.org/packages/optional/) available"
	einfo "which may be installed with portage as usual."

	if use testsuite ; then

	einfo ""
	einfo "To test Sage run the following command:"
	einfo ""
	einfo "  sage -tp 4 --all"
	einfo ""
	einfo "Replace the '4' with an adequate number of processes that are run in"
	einfo "parallel."
	einfo "Note that testing Sage may take more than an hour depending on your"
	einfo "processor. If you want to check your results look at the list of"
	einfo "known failures:"
	einfo ""
	einfo "  http://github.com/cschwan/sage-on-gentoo/wiki/Known-test-failures"

	fi
}
