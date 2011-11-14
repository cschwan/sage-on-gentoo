# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7:2.7"
PYTHON_USE_WITH="readline sage sqlite"

inherit distutils eutils flag-o-matic python versionator

MY_P="sage-$(replace_version_separator 2 '.')"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="examples mpc latex testsuite"

RESTRICT="mirror test"

CDEPEND="dev-libs/gmp
	>=dev-libs/mpfr-2.4.2
	>=dev-libs/ntl-5.5.2
	>=dev-libs/ppl-0.11.2
	>=dev-lisp/ecls-11.1.1-r1[-unicode]
	~dev-python/numpy-1.5.1
	>=sci-mathematics/eclib-20100711[pari24]
	>=sci-mathematics/ecm-6.2.1
	>=sci-libs/flint-1.5.0[ntl]
	>=sci-libs/fplll-3.0.12
	=sci-libs/givaro-3.2*
	>=sci-libs/gsl-1.15
	>=sci-libs/iml-1.0.1
	>=sci-libs/libcliquer-1.2_p7
	>=sci-libs/linbox-1.1.6[sage]
	>=sci-libs/m4ri-20100701
	>=sci-libs/mpfi-1.4
	=sci-libs/pynac-0.2.1-r1
	>=sci-libs/symmetrica-2.0
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/glpk-4.44
	=sci-mathematics/lcalc-1.23-r3[pari24]
	=sci-mathematics/pari-2.4.3-r1[data,gmp,sage]
	>=sci-mathematics/polybori-0.7[sage]
	>=sci-mathematics/ratpoints-2.1.3
	~sci-mathematics/sage-baselayout-${PV}[testsuite=]
	~sci-mathematics/sage-clib-${PV}
	~sci-libs/libsingular-3.1.1.4
	media-libs/gd[jpeg,png]
	media-libs/libpng
	>=sys-libs/readline-6.0
	sys-libs/zlib
	virtual/cblas
	mpc? ( dev-libs/mpc )"

DEPEND="${CDEPEND}
	=dev-python/cython-0.14.1-r1"

RDEPEND="${CDEPEND}
	>=dev-lang/R-2.10.1
	>=dev-python/cvxopt-1.1.3[glpk]
	>=dev-python/gdmodule-0.56-r2[png]
	>=dev-python/ipython-0.9.1
	>=dev-python/jinja-2.1.1
	>=dev-python/matplotlib-1.0.0
	>=dev-python/mpmath-0.16
	~dev-python/networkx-1.2
	~dev-python/pexpect-2.0
	>=dev-python/pycrypto-2.1.0
	>=dev-python/rpy-2.0.6
	>=dev-python/sphinx-1.0.4
	dev-python/sqlalchemy
	~dev-python/sympy-0.7.1
	>=media-gfx/tachyon-0.98[png]
	~net-zope/zodb-3.9.7
	>=sci-libs/cddlib-094f-r2
	=sci-libs/scipy-0.9*
	>=sci-mathematics/flintqs-20070817_p5
	>=sci-mathematics/gap-4.4.12
	>=sci-mathematics/genus2reduction-0.3_p8
	>=sci-mathematics/gfan-0.5
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912_p16
	>=sci-mathematics/maxima-5.23.2[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-1.1
	~sci-mathematics/sage-data-conway_polynomials-0.2
	~sci-mathematics/sage-data-elliptic_curves-0.1
	~sci-mathematics/sage-data-graphs-20070722_p1
	~sci-mathematics/sage-data-polytopes_db-20100210
	>=sci-mathematics/sage-doc-${PV}
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/singular-3.1.2
	>=sci-mathematics/sympow-1.018.1_p8[pari24]
	examples? ( ~sci-mathematics/sage-examples-${PV} )
	testsuite? (
		~sci-mathematics/sage-doc-${PV}[html]
		~sci-mathematics/sage-examples-${PV}
	)
	latex? (
		~dev-tex/sage-latex-2.2.5
		|| (
			app-text/dvipng[truetype]
			media-gfx/imagemagick[png]
		)
	)"
PDEPEND="~sci-mathematics/sage-notebook-0.8.14"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# TODO: put the following check into pkg_pretend once we may use EAPI 4 with
	# the python eclass
	if ( eselect blas show ; eselect lapack show ) | grep -q "atlas" ; then

	ewarn "You are about to compile Sage with ATLAS blas/lapack libraries. We"
	ewarn "discourage the use of atlas because of several small problems seen"
	ewarn "with version 3.9.23 in Sage's doctests. This is probably not a"
	ewarn "problem for everyday use of Sage but we have warned you!"

	fi

	# Sage now will only works with python 2.7.*
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	# ATLAS independence
	local cblaslibs=\'$(pkg-config --libs-only-l cblas | sed \
		-e 's/^-l//' \
		-e "s/ -l/\',\'/g" \
		-e 's/.,.pthread//g' \
		-e "s:  ::")\'

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# Fix startup issue and python-2.6.5 problem
	append-flags -fno-strict-aliasing

	epatch "${FILESDIR}"/${PN}-4.6.1-exp-site-packages.patch

	# add pari24 and gmp to everything.
	sed -i "s:\['stdc++', 'ntl'\]:\['stdc++', 'ntl','pari24','gmp'\]:g" \
		setup.py || die "failed to add pari24 and gmp everywhere"

	# use pari24 instead of plain pari
	sed -e "s:'pari':'pari24':g" \
		-i module_list.py \
		sage/misc/cython.py \
		|| die "failed to convert to pari24"

	sed -i "s:\"pari\":\"pari24\":" module_list.py \
		|| die "failed to convert to pari24"

	# pari/pari24 include patches
	sed -e "s:pari\/:pari24\/:g" \
		-i sage/libs/pari/pari_err.h \
		   sage/libs/pari/decl.pxi \
		   sage/libs/pari/misc.h \
		   sage/libs/pari/gen.pyx \
		   sage/ext/gen_interpreters.py \
		   sage/ext/interpreters/wrapper_cdf.pxd \
		   sage/matrix/matrix_integer_dense.pyx \
		   sage/matrix/matrix_rational_dense.pyx \
		   || die "failed to patch pari/pari24 includes"

	sed -i "s:cdef extern from \"pari\/:cdef extern from \"pari24\/:g" \
		sage/rings/fast_arith.pyx \
		|| die "failed to patch pari/pari24 includes in sage/rings/fast_arith.pyx"

	sed -e "s:gp --emacs --quiet --stacksize:gp-2.4 --emacs --quiet --stacksize:" \
		-e "s:%s/local/etc/gprc.expect'%SAGE_ROOT:${EPREFIX}/etc/gprc.expect':" \
		-i sage/interfaces/gp.py || die "failed to patch interfaces/gp.py"

	# use already installed csage
	rm -rf c_lib || die "failed to remove c library directory"

	# patch SAGE_LOCAL
	sed -i "s:SAGE_LOCAL = SAGE_ROOT + '/local':SAGE_LOCAL = os.environ['SAGE_LOCAL']:g" \
		setup.py || die "failed to patch SAGE_LOCAL"
	sed -i "s:SAGE_LOCAL = SAGE_ROOT + '/local/':SAGE_LOCAL = os.environ['SAGE_LOCAL']:g" \
		module_list.py || die "failed to patch SAGE_LOCAL"

	# fix polynomial_rational_flint.pyx include path - before it is done generally which screws up things
	sed -i "s:SAGE_ROOT + '/devel/sage/sage/libs/flint/':'sage/libs/flint/':"\
		module_list.py || die "failed to patch paths for polynomial_rational_flint.pyx"

	# fix include paths
	sed -i \
		-e "s:SAGE_ROOT[[:space:]]*+[[:space:]]*\([\'\"]\)/local/include/\([^\1]*\)\1:SAGE_LOCAL + \1/include/\2\1:g" \
		-e "s:sage/c_lib/include/:${EPREFIX}/usr/include/csage/:g" \
		module_list.py || die "failed to patch paths for libraries"
	# second pass for lines where there are two instances
	sed -i \
		-e "s:SAGE_ROOT[[:space:]]*+[[:space:]]*\([\'\"]\)/local/include/\([^\1]*\)\1:SAGE_LOCAL + \1/include/\2\1:g" \
		module_list.py || die "failed to patch paths for libraries 2"

	# fix library path for glpk
	sed -i -e "s:SAGE_ROOT+\"/local/lib/:SAGE_LOCAL + \"/lib/:" \
		module_list.py || die "failed to patch paths for glpk"

	sed -i "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py || die "failed to patch extensions path"

	# fix png library name
	sed -i "s:png12:$(libpng-config --libs | cut -dl -f2):g" \
		module_list.py || die "failed to patch png library name"

	# fix numpy path (final quote removed to catch numpy_include_dirs and numpy_depends)
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/numpy/core/include:'${EPREFIX}$(python_get_sitedir)/numpy/core/include:g" \
		module_list.py || die "failed to patch path for numpy include directory"

	# fix cython path
	sed -i \
		-e "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'${EPREFIX}$(python_get_sitedir)/Cython/Includes/':g" \
		-e "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/Deprecated/':'${EPREFIX}$(python_get_sitedir)/Cython/Includes/Deprecated/':g" \
		setup.py || die "failed to patch path for cython include directory"

	# fix lcalc path
	sed -i "s:include/lcalc/:include/Lfunction/:g" module_list.py \
		|| die "failed to patch path for lcalc include directory"

	# rebuild in place
	sed -i "s:SAGE_DEVEL + '/sage/sage/ext/interpreters':'sage/ext/interpreters':g" \
		setup.py || die "failed to patch interpreters path"

	# Do not overlink to cblas, this enable the gslcblas trick to solve issue 3
	sed -i "s:'iml', 'gmp', 'm', 'pari24', BLAS, BLAS2:'iml', 'gmp', 'm', 'pari24':" \
		module_list.py || die "failed to patch module_list.py for iml"

	# fix include paths and CBLAS/ATLAS
	sed -i \
		-e "s:'%s/include/csage'%SAGE_LOCAL:'${EPREFIX}/usr/include/csage':g" \
		-e "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py || die "failed to patch include paths"

	sed -i \
		-e "s:BLAS, BLAS2:${cblaslibs}:g" \
		-e "s:,BLAS:,${cblaslibs}:g" \
		module_list.py || die "failed to patch module_list.py for ATLAS"

	# Add -DNDEBUG to objects linking to libsingular
	sed -i "s:'/include/singular'\]:'/include/singular'\],extra_compile_args = \['-DNDEBUG'\]:g" \
		module_list.py || die "failed to add -DNDEBUG with libsingular"

	# TODO: why does Sage fail with linbox commentator ?

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# Fix issue #1
	sed -i "s:type.__cmp__:cmp:" sage/combinat/iet/strata.py \
		|| die "failed to patch strata.py"

	# other patch for python-2.7
	epatch "${FILESDIR}"/trac_11236-test_eq_for_python_2_7-nt.patch
	# Change python iclude in setup.py
	sed -i "s:python2.6:python2.7:g" setup.py
	# make sure we use cython-2.7 for consistency
	sed -i "s:python \`which cython\`:cython-2.7:" setup.py
	# deprecation warnings re-enabled
	epatch "${FILESDIR}"/trac_11244_reenable_deprecationwarnings_in_python27.patch
	epatch "${FILESDIR}"/trac_11244_fix_combinatpartition_warnings.patch
	epatch "${FILESDIR}"/trac_11244_fixmoredeprecationswarnings-4.7.patch
	# fixing pure numerical noise
	epatch "${FILESDIR}"/trac_9958-fixing_numericalnoise-part1-4.7.patch
	epatch "${FILESDIR}"/trac_9958-fixing_numericalnoise-part2-4.7.patch
	epatch "${FILESDIR}"/trac_9958-fixing_numericalnoise-part3.patch
	epatch "${FILESDIR}"/trac_9958-fixing_numericalnoise-part4.patch
	# other fixes
	epatch "${FILESDIR}"/trac_9958-sage_unittest.patch
	epatch "${FILESDIR}"/trac_9958-fix-list_index.patch
	epatch "${FILESDIR}"/trac_9958-fix-pureAssertError.patch
	epatch "${FILESDIR}"/trac_9958-mixedfix.patch
	epatch "${FILESDIR}"/trac_9958-fixing_colorspy.patch
	# fix groebner strategy trac 11339 using old work around
	epatch "${FILESDIR}"/trac_11339-groebner_strategy_deallocate.patch

	epatch "${FILESDIR}"/${PN}-4.6.2-gfan-0.5.patch
	# doctest fix for gsl-1.15
	epatch "${FILESDIR}"/trac_11357-fix_gsl_doctest.patch
	# update to sympy-0.7.0 trac 11560
	epatch "${FILESDIR}"/trac_11560-sympy_lexicographic_ordering.patch
	epatch "${FILESDIR}"/trac_11560-sympy_deprecated-each_char.patch

	# gmp-5 compatibility - works with gmp-4.3 as well
	sed -i "s:__GMP_BITS_PER_MP_LIMB:GMP_LIMB_BITS:g" sage/rings/integer.pyx \
		|| die "failed to patch for gmp-5"

	# run maxima with ecl
	sed -i \
		-e "s:maxima-noreadline:maxima -l ecl:g" \
		-e "s:maxima --very-quiet:maxima -l ecl --very-quiet:g" \
		sage/interfaces/maxima.py || die "failed to patch maxima commands"

	# Uses singular internal copy of the factory header
	sed -i "s:factory.h:singular/factory.h:" sage/libs/singular/singular-cdefs.pxi \
		|| die "failed to patch factory header"""

	# Fix portage QA warning. Potentially prevent some leaking.
	epatch "${FILESDIR}"/${PN}-4.4.2-flint.patch

	sed -i "s:cblas(), atlas():${cblaslibs}:" sage/misc/cython.py \
		|| die "failed to patch cython.py for ATLAS"

	# patch for glpk
	sed -i \
		-e "s:\.\./\.\./\.\./\.\./devel/sage/sage:..:g" \
		-e "s:\.\./\.\./\.\./local/include/::g" \
		sage/numerical/backends/glpk_backend.pxd || die "failed to patch glpk backend"

	# Ticket #5155:

	# save gap_stamp to directory where sage is able to write
	sed -i "s:GAP_STAMP = '%s/local/bin/gap_stamp'%SAGE_ROOT:GAP_STAMP = '%s/gap_stamp'%DOT_SAGE:g" \
		sage/interfaces/gap.py || die "patch to gap interface"

	# fix qepcad paths
	epatch "${FILESDIR}"/${PN}-4.5.1-fix-qepcad-path.patch

	# replace SAGE_ROOT/local with SAGE_LOCAL
	epatch "${FILESDIR}"/${PN}-4.6-fix-SAGE_LOCAL.patch

	# patch path for saving sessions
	sed -i "s:save_session('tmp_f', :save_session(tmp_f, :g" \
		sage/misc/session.pyx || die "failed to patch session path"

	# patch lie library path
	sed -i "s:open(SAGE_LOCAL + 'lib/lie/INFO\.0'):open(SAGE_LOCAL + '/share/lie/INFO.0'):g" \
		sage/interfaces/lie.py || die "failed to patch lie library path"

	# Patch to singular info file shipped with sage-doc
	sed -i "s:os.environ\[\"SAGE_LOCAL\"\]+\"/share/singular/\":os.environ\[\"SAGE_DOC\"\]+\"/\":g" \
		sage/interfaces/singular.py || die "failed to patch singular.hlp path"

	# fix test paths
	sed -i \
		-e "s:'my_animation.gif':tmp_filename('my_animation')+'.gif':g" \
		-e "s:'wave.gif':tmp_filename('wave')+'.gif':g" \
		-e "s:'wave0.sobj':tmp_filename('wave0')+'.sobj':g" \
		-e "s:'wave1.sobj':tmp_filename('wave1')+'.sobj':g" \
		sage/plot/animate.py

	# enable dev-libs/mpc if required
	if use mpc ; then
		sed -i "s:is_package_installed('mpc'):True:g" module_list.py \
			|| die "failed to enable dev-libs/mpc"
	fi

	# apply patches from /etc/portage/patches
	epatch_user

	# do not forget to run distutils
	distutils_src_prepare
}

src_configure() {
	export SAGE_LOCAL="${EPREFIX}"/usr/
	export SAGE_ROOT="${EPREFIX}"/usr/share/sage
	export SAGE_VERSION=${PV}
	export DOT_SAGE="${S}"

	export MAKE=${MAKEOPTS}

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

src_install() {
	distutils_src_install

	if use testsuite ; then
		# install testable sources and sources needed for testing
		find sage ! \( -name "*.py" -o -name "*.pyx" -o -name "*.pxd" -o \
			-name "*.pxi" \) -type f -delete \
			|| die "failed to remove non-testable sources"

		insinto /usr/share/sage/devel/sage-main
		doins -r sage || die
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
	einfo "You have installed Sage's testsuite. In order to test Sage run the"
	einfo "following command in a directory where Sage may write to, e.g.:"
	einfo ""
	einfo "  cd \$(mktemp -d) && sage -testall"
	einfo ""
	einfo "After testing has finished, NO FILES SHOULD BE LEFT in this"
	einfo "directory. If this is not the case, please send us a bug report."
	einfo "Parallel doctesting is also possible (replace '8' with an adequate"
	einfo "number of processes):"
	einfo ""
	einfo "  cd \$(mktemp -d) && sage -tp 8 -sagenb \\"
	einfo "      ${EPREFIX}/usr/share/sage/devel/sage-main/"
	einfo ""
	einfo "Note that testing Sage may take more than 4 hours. If you want to"
	einfo "check your results look at the list of known failures:"
	einfo ""
	einfo "  http://github.com/cschwan/sage-on-gentoo/wiki/Known-test-failures"

	fi
}
