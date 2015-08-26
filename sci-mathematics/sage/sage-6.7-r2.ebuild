# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="readline,sqlite"

inherit distutils-r1 eutils flag-o-matic multilib multiprocessing prefix toolchain-funcs versionator

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/sagemath/sage.git"
	EGIT_BRANCH=develop
	EGIT_SOURCEDIR="${WORKDIR}/${P}"
	inherit git-2
	SAGE_DOC_DEP="~sci-mathematics/sage-doc-${PV}"
	SAGE_DOC_DEP_HTML="~sci-mathematics/sage-doc-${PV}[html]"
	KEYWORDS=""
else
	SRC_URI="mirror://sagemath/${PV}.tar.gz -> ${P}.tar.gz"
	SAGE_DOC_DEP="|| ( ~sci-mathematics/sage-doc-bin-${PV} ~sci-mathematics/sage-doc-${PV} )"
	SAGE_DOC_DEP_HTML="|| ( ~sci-mathematics/sage-doc-bin-${PV}[html] ~sci-mathematics/sage-doc-${PV}[html] )"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
fi

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="${SRC_URI}
	mirror://sagemath/patches/${PN}-6.7-r7-neutering.tar.xz"

LICENSE="GPL-2"
SLOT="0"
SAGE_USE="arb modular_decomposition bliss"
IUSE="latex testsuite debug ${SAGE_USE}"

RESTRICT="mirror test"

CDEPEND="dev-libs/gmp:0=
	>=dev-libs/mpfr-3.1.0
	>=dev-libs/mpc-1.0
	~dev-libs/ntl-6.2.1
	>=dev-libs/ppl-1.1
	>=dev-lisp/ecls-13.5.1
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	~dev-python/cython-0.22[${PYTHON_USEDEP}]
	>=sci-mathematics/eclib-20150510[flint]
	>=sci-mathematics/gmp-ecm-6.4.4[-openmp]
	>=sci-mathematics/flint-2.5.2[ntl]
	~sci-libs/fplll-4.0.4
	~sci-libs/givaro-3.7.1
	>=sci-libs/gsl-1.16
	>=sci-libs/iml-1.0.4
	~sci-libs/libcliquer-1.21_p1
	~sci-libs/libgap-4.7.7
	~sci-libs/linbox-1.3.2[sage]
	~sci-libs/m4ri-20140914
	~sci-libs/m4rie-20140914
	>=sci-libs/mpfi-1.5.1
	~sci-libs/pynac-0.3.7[${PYTHON_USEDEP}]
	>=sci-libs/symmetrica-2.0-r3
	>=sci-libs/zn_poly-0.9
	sci-mathematics/glpk:0=
	>=sci-mathematics/lcalc-1.23-r6[pari]
	>=sci-mathematics/lrcalc-1.1.6_beta1
	~sci-mathematics/pari-2.8_pre20150510[data,gmp,doc]
	>=sci-mathematics/polybori-0.8.3[${PYTHON_USEDEP}]
	>=sci-mathematics/ratpoints-2.1.3
	~sci-mathematics/sage-baselayout-${PV}[testsuite=,${PYTHON_USEDEP}]
	~sci-mathematics/sage-clib-${PV}
	~sci-libs/libsingular-3.1.7_p1[flint]
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	>=sys-libs/readline-6.2
	sys-libs/zlib
	dev-python/pkgconfig
	virtual/cblas
	arb? ( >=sci-mathematics/arb-2.5.0 )
	modular_decomposition? ( sci-libs/modular_decomposition )
	bliss? ( sci-libs/bliss )"

DEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}
	>=dev-lang/R-3.2.0
	>=dev-python/cvxopt-1.1.7[glpk,${PYTHON_USEDEP}]
	>=dev-python/ipython-3.1.0[notebook,${PYTHON_USEDEP}]
	>=dev-python/jinja-2.5.5[${PYTHON_USEDEP}]
	=dev-python/matplotlib-1.4*[${PYTHON_USEDEP}]
	>=dev-python/mpmath-0.18[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.8[${PYTHON_USEDEP}]
	~dev-python/sage-pexpect-2.0[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.3.8[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/sympy-0.7.5[${PYTHON_USEDEP}]
	~media-gfx/tachyon-0.98.9[png]
	>=sci-libs/cddlib-094f-r2
	>=sci-libs/scipy-0.14.0[${PYTHON_USEDEP}]
	>=sci-mathematics/flintqs-20070817
	~sci-mathematics/gap-4.7.7
	~sci-mathematics/gfan-0.5
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	~sci-mathematics/maxima-5.35.1[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-elliptic_curves-0.7
	~sci-mathematics/sage-data-graphs-20130920
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-polytopes_db-20120220
	~sci-mathematics/singular-3.1.7_p1
	>=sci-mathematics/sympow-1.018.1
	www-servers/tornado
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
	latex? (
		~dev-tex/sage-latex-2.3.4
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)"

PDEPEND="=sci-mathematics/sage-notebook-0.11.4-r2[${PYTHON_USEDEP}]
	~sci-mathematics/sage-data-conway_polynomials-0.4
	${SAGE_DOC_DEP}
	testsuite? ( ${SAGE_DOC_DEP_HTML} )"

S="${WORKDIR}/${P}/src"

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

python_prepare() {
	# ATLAS independence
	epatch "${FILESDIR}"/${PN}-6.7-blas.patch

	# Remove sage's package management system
	epatch "${WORKDIR}"/patches/${PN}-6.7-package.patch
	rm sage/misc/package.py
	# remove the install_script facility
	rm sage/misc/dist.py

	# Remove sage's git capabilities
	epatch "${WORKDIR}"/patches/${PN}-6.5-hg.patch
	rm -rf sage/dev

	# Remove sage cmdline tests related to these
	epatch "${WORKDIR}"/patches/${PN}-6.7-cmdline.patch

	# replace pexpect with sage pinned version
	epatch "${FILESDIR}"/${PN}-6.2-pexpect.patch
	sed -i "s:import pexpect:import sage_pexpect as pexpect:g" \
		`grep -rl "import pexpect" *`
	sed -i "s:from pexpect:from sage_pexpect:g" \
		`grep -rl "from pexpect" *`

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# use already installed csage
	# but we need to keep the include directory while clib is in the process of being removed.
	rm -rf c_lib/src || die "failed to remove c library source directory"

	# fix png library name
	sed -i "s:png12:$(libpng-config --libs | cut -dl -f2):g" module_list.py

	# fix lcalc path
	sed -i "s:SAGE_INC + \"/libLfunction:SAGE_INC + \"/Lfunction:g" module_list.py

	# We add -DNDEBUG to objects linking to givaro and libsingular And use factory headers from libsingular.
	epatch "${FILESDIR}"/${PN}-6.4-givaro_singular_extra.patch

	# Do not clean up the previous install with setup.py
	epatch "${FILESDIR}"/${PN}-6.3-noclean.patch

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# sage on gentoo env.py
	epatch "${FILESDIR}"/sage-6.7-env.patch
	eprefixify sage/env.py

	# Upgrade matplotlib to 1.4.x
	epatch "${FILESDIR}"/MPL-1.4.patch

	# fix library path of libsingular
	sed -i "s:os.environ\['SAGE_LOCAL'\]+\"/lib:\"${EPREFIX}/usr/$(get_libdir):" \
		sage/libs/singular/singular.pyx

	# TODO: should be a patch
	# run maxima with ecl
	sed -i "s:'maxima :'maxima -l ecl :g" \
		sage/interfaces/maxima.py \
		sage/interfaces/maxima_abstract.py

	# TODO: should be a patch
	# Uses singular internal copy of the factory header
	sed -i "s:factory/factory.h:singular/factory.h:" \
		sage/libs/singular/singular-cdefs.pxi

	# finding JmolData.jar in the right place
	sed -i "s:\"jmol\", \"JmolData:\"sage-jmol-bin\", \"lib\", \"JmolData:" sage/interfaces/jmoldata.py

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

	# The ipython kernel tries to to start a new session via $SAGE_ROOT/sage -python
	# Since we don't have $SAGE_ROOT/sage it fails.
	#See https://github.com/cschwan/sage-on-gentoo/issues/342
	epatch "${FILESDIR}"/${PN}-6.6-ipython_kernel_start.patch

	# Make sure bliss header are found
	sed -i "s:graph.hh:bliss/graph.hh:" sage/graphs/bliss.pyx || die "bliss.pyx not patched"

	############################################################################
	# Fixes to doctests
	############################################################################

	# TODO: should be a patch
	# remove 'local' part
	sed -i "s:\.\.\./local/share/pari:.../share/pari:g" sage/interfaces/gp.py

	# fix all.py
	epatch "${FILESDIR}"/${PN}-6.0-all.py.patch
	sed -i \
		-e "s:\"lib\",\"python\":\"$(get_libdir)\",\"${EPYTHON}\":" \
		-e "s:\"bin\":\"lib\",\"python-exec\",\"${EPYTHON}\":" sage/all.py

	# do not test safe python stuff from trac 13579
	epatch "${FILESDIR}"/${PN}-6.6-safepython.patch

	# 'sage' is not in SAGE_ROOT, but in PATH
	epatch "${FILESDIR}"/${PN}-5.9-fix-ostools-doctest.patch

	# change the location of the doc building tools in sage/doctest/control.py
	epatch "${FILESDIR}"/${PN}-6.3-doc_common.patch

	# fix location of the html doc
	epatch "${FILESDIR}"/${PN}-6.6-sagedoc.patch
}

python_configure() {
	export SAGE_LOCAL="${EPREFIX}"/usr/
	export SAGE_ROOT="${EPREFIX}"/usr/share/sage
	export SAGE_SRC=`pwd`
	export SAGE_VERSION=${PV}
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	for option in ${SAGE_USE}; do
		use $option && export WANT_$option="True"
	done
	if use debug; then
		export SAGE_DEBUG=1
	fi

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"

	# autogenerate pari files
	# This is done src/Makefile in vanilla sage - we don't want to use the Makefile, even patched.
	"${PYTHON}" -c "from sage_setup.autogen.pari import rebuild; rebuild()"
	"${PYTHON}" -c "from sage_setup.autogen.interpreters import rebuild; rebuild('sage/ext/interpreters')"
}

python_install_all() {
	# Do not install sage_setup at all (but this is needed at the begining).
	rm -rf sage_setup

	distutils-r1_python_install_all

	# install sources needed for testing/compiling of cython/spyx files
	find sage ! \( -name "*.py" -o -name "*.pyx" -o -name "*.pxd" -o \
		-name "*.pxi" -o -name "*.h" \
		-o -name "*matrix_rational_dense_linbox.cpp" \
		-o -name "*wrap.cc" \
		-o -name "*.rst" \) -type f -delete \
		|| die "failed to remove non-testable sources"

	insinto /usr/share/sage/src
	doins -r sage
	if use debug; then
		# TODO make it usable if it is installed directly under src rather than src/build
		insinto /usr/share/sage/src/build
		pushd build
		doins -r cython_debug
		popd
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
	einfo "To test Sage with 4 parallel processes run the following command:"
	einfo ""
	einfo "  sage -tp 4 --all"
	einfo ""
	einfo "Note that testing Sage may take more than an hour depending on your"
	einfo "processor(s). You _will_ see failures but many of them are harmless"
	einfo "such as version mismatches and numerical noise. Since Sage is"
	einfo "changing constantly we do not maintain an up-to-date list of known"
	einfo "failures."

	fi

	einfo ""
	einfo "IF YOU EXPERIENCE PROBLEMS and wish to report them please use the"
	einfo "overlay's issue tracker at"
	einfo ""
	einfo "  https://github.com/cschwan/sage-on-gentoo/issues"
	einfo ""
	einfo "There we can react faster than on bugs.gentoo.org where bugs first"
	einfo "need to be assigned to the right person. Thank you!"
}
