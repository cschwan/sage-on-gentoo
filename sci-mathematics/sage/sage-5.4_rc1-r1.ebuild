# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.7:2.7"
PYTHON_USE_WITH="readline sqlite"

inherit prefix distutils eutils flag-o-matic python versionator

MY_P="sage-$(replace_version_separator 2 '.')"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="latex testsuite"

RESTRICT="mirror test"

CDEPEND="dev-libs/gmp
	>=dev-libs/mpfr-3.1.0
	>=dev-libs/mpc-1.0
	>=dev-libs/ntl-5.5.2
	>=dev-libs/ppl-0.11.2
	>=dev-lisp/ecls-11.1.1-r1
	~dev-python/numpy-1.5.1
	~dev-python/cython-0.17_pre
	~sci-mathematics/eclib-20120428
	>=sci-mathematics/ecm-6.3
	>=sci-libs/flint-1.5.2[ntl]
	~sci-libs/fplll-3.0.12
	~sci-libs/givaro-3.7.1
	>=sci-libs/gsl-1.15
	>=sci-libs/iml-1.0.1
	>=sci-libs/libcliquer-1.2_p11
	~sci-libs/linbox-1.3.2[sage]
	~sci-libs/m4ri-20120613
	~sci-libs/m4rie-20120613
	>=sci-libs/mpfi-1.5
	~sci-libs/pynac-0.2.5
	>=sci-libs/symmetrica-2.0
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/glpk-4.44
	>=sci-mathematics/lcalc-1.23-r4[pari]
	sci-mathematics/lrcalc
	~sci-mathematics/pari-2.5.2[data,gmp]
	~sci-mathematics/polybori-0.8.2
	>=sci-mathematics/ratpoints-2.1.3
	~sci-mathematics/sage-baselayout-${PV}[testsuite=]
	~sci-mathematics/sage-clib-${PV}
	~sci-libs/libsingular-3.1.5
	media-libs/gd[jpeg,png]
	media-libs/libpng
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas"

DEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}
	>=dev-lang/R-2.14.0
	>=dev-python/cvxopt-1.1.5[glpk]
	>=dev-python/gdmodule-0.56-r2[png]
	~dev-python/ipython-0.10.2
	>=dev-python/jinja-2.5.5
	>=dev-python/matplotlib-1.1.0
	>=dev-python/mpmath-0.17
	~dev-python/networkx-1.6
	~dev-python/pexpect-2.0
	>=dev-python/pycrypto-2.1.0
	>=dev-python/rpy-2.0.8
	>=dev-python/sphinx-1.1.2
	dev-python/sqlalchemy
	~dev-python/sympy-0.7.1
	>=media-gfx/tachyon-0.98.9[png]
	net-zope/zodb
	>=sci-libs/cddlib-094f-r2
	>=sci-libs/scipy-0.9
	>=sci-mathematics/flintqs-20070817_p6
	>=sci-mathematics/gap-4.4.12
	>=sci-mathematics/genus2reduction-0.3_p8-r1
	~sci-mathematics/gfan-0.5
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912_p18
	~sci-mathematics/maxima-5.26.0[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-conway_polynomials-0.3
	~sci-mathematics/sage-data-elliptic_curves-0.7
	~sci-mathematics/sage-data-graphs-20120404_p4
	~sci-mathematics/sage-data-polytopes_db-20100210_p2
	>=sci-mathematics/sage-doc-${PV}
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/singular-3.1.5
	>=sci-mathematics/sympow-1.018.1_p11
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
	testsuite? ( >=sci-mathematics/sage-doc-${PV}[html] )
	latex? (
		~dev-tex/sage-latex-2.3.3_p2
		|| (
			app-text/dvipng[truetype]
			media-gfx/imagemagick[png]
		)
	)"

PDEPEND="~sci-mathematics/sage-notebook-0.10.2"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
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

	# patch to module_list.py because of trac 4539
	epatch "${FILESDIR}"/${PN}-5.4-plural.patch
	# fix a stupid include path to devel
	epatch "${FILESDIR}"/${PN}-5.0-degree-sequence.patch

	# make sure we use cython-2.7 for consistency
	sed -i "s:python \`which cython\`:cython-2.7:" setup.py

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# Fix startup issue and python-2.6.5 problem
	append-flags -fno-strict-aliasing

	epatch "${FILESDIR}"/${PN}-4.7.2-site-packages.patch

	# add pari and gmp to everything.
	sed -i "s:\['stdc++', 'ntl'\]:\['stdc++', 'ntl','pari','gmp'\]:g" setup.py

	sed -e "s:%s/local/etc/gprc.expect'%SAGE_ROOT:${EPREFIX}/etc/gprc.expect':" \
		-i sage/interfaces/gp.py

	# use already installed csage
	rm -rf c_lib || die "failed to remove c library directory"

	# patch SAGE_LOCAL
	sed -i "s:SAGE_LOCAL = SAGE_ROOT + '/local':SAGE_LOCAL = os.environ['SAGE_LOCAL']:g" \
		setup.py
	sed -i "s:SAGE_LOCAL = SAGE_ROOT + '/local':SAGE_LOCAL = os.environ['SAGE_LOCAL']:g" \
		module_list.py

	sed -i "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py

	# fix misc/dist.py
	epatch "${FILESDIR}"/${PN}-4.8-dist.py.patch

	# fix png library name
	sed -i "s:png12:$(libpng-config --libs | cut -dl -f2):g" \
		module_list.py

	# fix numpy path (final quote removed to catch numpy_include_dirs and numpy_depends)
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/numpy/core/include:'${EPREFIX}$(python_get_sitedir)/numpy/core/include:g" \
		module_list.py

	# fix cython path
	sed -i \
		-e "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'${EPREFIX}$(python_get_sitedir)/Cython/Includes/':g" \
		-e "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/Deprecated/':'${EPREFIX}$(python_get_sitedir)/Cython/Includes/Deprecated/':g" \
		setup.py

	# fix lcalc path
	sed -i "s:SAGE_INC + \"lcalc:SAGE_INC + \"Lfunction:g" module_list.py

	# build the lrcalc module
	sed -i "s:is_package_installed('lrcalc'):True:g" module_list.py

	# rebuild in place
	sed -i "s:SAGE_DEVEL + '/sage/sage/ext/interpreters':'sage/ext/interpreters':g" \
		setup.py

	# fix include paths and CBLAS/ATLAS
	sed -i \
		-e "s:'%s/include/csage'%SAGE_LOCAL:'${EPREFIX}/usr/include/csage':g" \
		-e "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py

	sed -i \
		-e "s:BLAS, BLAS2:${cblaslibs}:g" \
		-e "s:,BLAS:,${cblaslibs}:g" \
		module_list.py

	# Add -DNDEBUG to objects linking to libsingular and use factory headers from singular.
	sed -i "s:'singular', SAGE_INC + 'factory'\],:'singular'\],:g" \
		module_list.py
	#epatch "${FILESDIR}"/sage-5.4-singular_extra.patch

	# Add -DNDEBUG to objects linking to givaro. It solves problems with linbox.
	sed -i "s:-D__STDC_LIMIT_MACROS:-D__STDC_LIMIT_MACROS -DNDEBUG:g" \
		module_list.py

	# TODO: why does Sage fail with linbox commentator ?

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# eliminate the creation and test of the sagestarted.txt file, trac 11926 (11926_sage.patch)
	epatch "${FILESDIR}"/${PN}-5.1-sagestarted.patch

	# issue 85 a test crashes earlier than vanilla
	sed -i "s|sage: x = dlx_solver(rows)|sage: x = dlx_solver(rows) # not tested|" \
		sage/combinat/tiling.py

	# update to gfan-0.5 trac 11395
	epatch "${FILESDIR}"/trac_11395_update_gfan_to_0.5.patch
	epatch "${FILESDIR}"/trac11395-fix_tutorial.patch

	# run maxima with ecl
	sed -i \
		-e "s:maxima-noreadline:maxima -l ecl:g" \
		sage/interfaces/maxima.py
	sed -i \
		-e "s:maxima --very-quiet:maxima -l ecl --very-quiet:g" \
		sage/interfaces/maxima_abstract.py

	# speaking ecl - patching so we can allow ecl with unicode hopefully in 5.3
	epatch "${FILESDIR}"/trac12985-unicode.patch

	# Uses singular internal copy of the factory header
	sed -i "s:factory/factory.h:singular/factory.h:" sage/libs/singular/singular-cdefs.pxi

	# Fix portage QA warning. Potentially prevent some leaking.
	epatch "${FILESDIR}"/${PN}-4.4.2-flint.patch

	sed -i "s:cblas(), atlas():${cblaslibs}:" sage/misc/cython.py

	# patch for glpk
	sed -i \
		-e "s:\.\./\.\./\.\./\.\./devel/sage/sage:..:g" \
		-e "s:\.\./\.\./\.\./local/include/::g" \
		sage/numerical/backends/glpk_backend.pxd

	# Ticket #5155:

	# save gap_stamp to directory where sage is able to write
	sed -i "s:GAP_STAMP = SAGE_EXTCODE:GAP_STAMP = '%s/gap_stamp'%DOT_SAGE:g" \
		sage/interfaces/gap.py

	# fix qepcad paths
	epatch "${FILESDIR}"/${PN}-5.4-fix-qepcad-path.patch

	# replace SAGE_ROOT/local with SAGE_LOCAL and fix variables
	epatch "${FILESDIR}"/${PN}-5.4-fix-SAGE_LOCAL.patch
	epatch "${FILESDIR}"/${PN}-5.4-misc.patch
	eprefixify sage/misc/misc.py

	# patch path for saving sessions
	sed -i "s:save_session('tmp_f', :save_session(tmp_f, :g" \
		sage/misc/session.pyx

	# make is_installed always return false
	epatch "${FILESDIR}"/${PN}-5.4-package.patch

	# patch lie library path
	sed -i -e "s:/lib/LiE/:/share/lie/:" \
		sage/interfaces/lie.py

	# Patch to singular info file shipped with sage-doc
	sed -i "s:os.environ\[\"SAGE_LOCAL\"\]+\"/share/singular/\":os.environ\[\"SAGE_DOC\"\]+\"/\":g" \
		sage/interfaces/singular.py

	# fix the cmdline test using SAGE_ROOT
	sed -i "s:SAGE_ROOT, \"local\":os.environ[\"SAGE_LOCAL\"]:" \
		sage/tests/cmdline.py

	# fix all paths using SAGE_ROOT or other
	# polymake
	sed -i "s:%s/local/polymake/bin/'%os.environ\['SAGE_ROOT'\]:%s/bin/'%os.environ\['SAGE_LOCAL'\]:" \
		sage/geometry/polytope.py
	# kash-bin documentation
	sed -i "s:%s/local/lib/kash/html\"%os.environ\['SAGE_ROOT'\]:${EPREFIX}/opt/kash3/html:" \
		sage/interfaces/kash.py
	# sandpile.py
	sed \
		-e "s:SAGE_ROOT+'/local/bin/':SAGE_LOCAL+'/bin':g" \
		-e "s:SAGE_ROOT = os.environ\['SAGE_ROOT'\]:SAGE_LOCAL = os.environ\['SAGE_LOCAL'\]:" \
		-i sage/sandpiles/sandpile.py

	# Final SAGE_ROOT elimination
	epatch "${FILESDIR}"/${PN}-5.4-SAGE_ROOT.patch

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

	# parse MAKEOPTS and extract the number of jobs (from dev-libs/boost)
	local jobs=$(echo " ${MAKEOPTS} " | sed \
		-e 's/ --jobs[= ]/ -j /g' \
		-e 's/ -j \([1-9][0-9]*\)/ -j\1/g' \
		-e 's/ -j\>/ -j1/g' | \
		( while read -d ' ' j; do
			if [[ "${j#-j}" = "$j" ]]; then
				continue
			fi
			jobs="${j#-j}"
			done
			echo ${jobs} )
	)
	if [[ "${jobs}" != "" ]]; then
		export SAGE_NUM_THREADS="${jobs}"
	else
		export SAGE_NUM_THREADS=1
	fi

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

src_install() {
	distutils_src_install

	# install sources needed for testing and compiling of cython files and spyx files
	find sage ! \( -name "*.py" -o -name "*.pyx" -o -name "*.pxd" -o \
		-name "*.pxi" -o -name "*.h" \
		-o -name "*fmpq_poly.c" \
		-o -name "*matrix_rational_dense_linbox.cpp" \
		-o -name "*wrap.cc" \) -type f -delete \
		|| die "failed to remove non-testable sources"

	insinto /usr/share/sage/devel/sage-main
	doins -r sage || die
}

pkg_postinst() {
	distutils_pkg_postinst

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
