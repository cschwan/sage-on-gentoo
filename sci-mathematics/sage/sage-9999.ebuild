# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="readline,sqlite"

inherit distutils-r1 eutils flag-o-matic multilib multiprocessing prefix toolchain-funcs versionator

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/sagemath/sage.git"
	EGIT_BRANCH=develop
	EGIT_SOURCEDIR="${WORKDIR}/${P}"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="mirror://sagemath/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
fi

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="${SRC_URI}
	mirror://sagemath/patches/${PN}-6.8-neutering.patch.xz
	mirror://sagemath/patches/sage-icon.tar.bz2
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-6/Singular-3-1-6-share.tar.gz"

LANGS="ca de en fr hu it pt ru tr"

LICENSE="GPL-2"
SLOT="0"
SAGE_USE="arb modular_decomposition bliss"
IUSE="latex testsuite debug X html pdf ${SAGE_USE}"
LINGUAS_USEDEP=""
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
	LINGUAS_USEDEP="${LINGUAS_USEDEP}linguas_${X}=,"
done
LINGUAS_USEDEP="${LINGUAS_USEDEP%?}"

RESTRICT="mirror test"

CDEPEND="dev-libs/gmp:0=
	>=dev-libs/mpfr-3.1.0
	>=dev-libs/mpc-1.0
	>=dev-libs/ntl-9.3.0
	>=dev-libs/ppl-1.1
	>=dev-lisp/ecls-15.3.7
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/cython-0.23_beta1[${PYTHON_USEDEP}]
	dev-python/pkgconfig
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	~dev-python/sphinx-1.2.2[${PYTHON_USEDEP}]
	>=sci-mathematics/eclib-20150510[flint]
	>=sci-mathematics/gmp-ecm-6.4.4[-openmp]
	>=sci-mathematics/flint-2.4.4[ntl]
	~sci-libs/fplll-4.0.4
	~sci-libs/givaro-3.7.1
	>=sci-libs/gsl-1.16
	>=sci-libs/iml-1.0.4
	~sci-libs/libcliquer-1.21_p1
	~sci-libs/libgap-4.7.8
	~sci-libs/linbox-1.3.2[sage]
	~sci-libs/m4ri-20140914
	~sci-libs/m4rie-20140914
	>=sci-libs/mpfi-1.5.1
	~sci-libs/pynac-0.3.9.2[${PYTHON_USEDEP}]
	>=sci-libs/symmetrica-2.0-r3
	>=sci-libs/zn_poly-0.9
	sci-mathematics/glpk:0=[gmp]
	>=sci-mathematics/lcalc-1.23-r6[pari]
	>=sci-mathematics/lrcalc-1.1.6_beta1
	>=sci-mathematics/pari-2.8_pre20150611[data,gmp,doc]
	~sci-mathematics/planarity-2.2.0
	>=sci-mathematics/polybori-0.8.3[${PYTHON_USEDEP}]
	>=sci-mathematics/ratpoints-2.1.3
	>=sci-mathematics/rw-0.7
	~sci-libs/libsingular-3.1.7_p1[flint]
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas
	arb? ( >=sci-mathematics/arb-2.6.0 )
	modular_decomposition? ( sci-libs/modular_decomposition )
	bliss? ( sci-libs/bliss )
	pdf? ( app-text/texlive[extra,${LINGUAS_USEDEP}] )
	!sci-mathematics/sage-baselayout
	!sci-mathematics/sage-clib
	!sci-mathematics/sage-doc
	!sci-mathematics/sage-doc-bin"

DEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}
	>=dev-lang/R-3.2.0
	>=dev-python/cvxopt-1.1.7[glpk,${PYTHON_USEDEP}]
	>=dev-python/ipython-3.2.1[notebook,${PYTHON_USEDEP}]
	>=dev-python/jinja-2.5.5[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/mpmath-0.18[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.8[${PYTHON_USEDEP}]
	>=dev-python/pexpect-3.3-r1[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.3.8[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/sympy-0.7.5[${PYTHON_USEDEP}]
	~media-gfx/tachyon-0.98.9[png]
	>=sci-libs/cddlib-094f-r2
	>=sci-libs/scipy-0.14.0[${PYTHON_USEDEP}]
	>=sci-mathematics/flintqs-20070817
	~sci-mathematics/gap-4.7.8
	~sci-mathematics/gfan-0.5
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	~sci-mathematics/maxima-5.35.1[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-elliptic_curves-0.8
	~sci-mathematics/sage-data-graphs-20150724
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-polytopes_db-20120220
	~sci-mathematics/sage-data-conway_polynomials-0.4
	~sci-mathematics/singular-3.1.7_p1
	>=sci-mathematics/sympow-1.018.1
	www-servers/tornado
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
	latex? (
		~dev-tex/sage-latex-2.3.4
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)"

PDEPEND=">=sci-mathematics/sage-notebook-0.11.4-r3[${PYTHON_USEDEP}]"

CHECKREQS_DISK_BUILD="5G"

S="${WORKDIR}/${P}/src"

REQUIRED_USE="html? ( linguas_en )
	testsuite? ( html )"

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

python_prepare() {
	#########################################
	#
	# scripts under src/bin and miscellanous files
	#
	#########################################

	# ship our own version of sage-env
	cp "${FILESDIR}"/proto.sage-env-6.8 bin/sage-env
	eprefixify bin/sage-env
	sed -i "s:@GENTOO_SITEDIR@:$(python_get_sitedir):" bin/sage-env

	# make .desktop file
	cat > "${T}"/sage-sage.desktop <<-EOF
		[Desktop Entry]
		Name=Sage Shell
		Type=Application
		Comment=Math software for algebra, geometry, number theory, cryptography and numerical computation
		Exec=sage
		TryExec=sage
		Icon=sage
		Categories=Education;Science;Math;
		Terminal=true
	EOF

	# Remove useless SAGE_ROOT and SAGE_LOCAL
	sed -i \
		-e "s:\$SAGE_ROOT/local/bin/::" \
		-e "s:\$SAGE_LOCAL/bin/::" \
		bin/sage-cachegrind \
		bin/sage-massif \
		bin/sage-omega \
		bin/sage-valgrind

	# replace MAKE by MAKEOPTS in sage-num-threads.py
	sed -i "s:os.environ\[\"MAKE\"\]:os.environ\[\"MAKEOPTS\"\]:g" \
		bin/sage-num-threads.py

	# remove developer and unsupported options
	epatch "${FILESDIR}"/${PN}-6.9-exec.patch
	eprefixify bin/sage

	# create expected folders under extcode
	mkdir -p ext/sage

	###############################
	#
	# Patches to the sage library
	#
	###############################

	# ATLAS independence
	epatch "${FILESDIR}"/${PN}-6.8-blas-r1.patch

	# Remove sage's package management system, git capabilities and associated tests
	epatch "${WORKDIR}"/${PN}-6.8-neutering.patch
	rm sage/misc/package.py
	rm sage/misc/dist.py
	rm -rf sage/dev

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# fix png library name
	sed -i "s:png12:$(libpng-config --libs | cut -dl -f2):g" module_list.py

	# fix lcalc path
	sed -i "s:libLfunction:Lfunction:g" sage/libs/lcalc/lcalc_sage.h

	# We add -DNDEBUG to objects linking to libsingular And use factory headers from libsingular.
	epatch "${FILESDIR}"/${PN}-6.8-singular_extra_arg.patch

	# Upgrade to cython 0.23_beta
	epatch "${FILESDIR}"/cython-0.23.patch

	# Do not clean up the previous install with setup.py
	# Get headers generated by cython installed and found at runtime and buildtime
	# Also install all appropriate sources alongside python code.
	epatch "${FILESDIR}"/${PN}-6.8-sources-r1.patch
	touch sage/doctest/tests/__init__.py

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# sage on gentoo env.py
	epatch "${FILESDIR}"/sage-6.8-env.patch
	eprefixify sage/env.py

	# sage-maxima.lisp really belong to /etc
	epatch "${FILESDIR}"/sage-6.8-maxima.lisp.patch

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
		sage/libs/singular/decl.pxd

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

	# Make the lazy_import pickle name versioned with the sage version number
	# rather than the path to the source which is a constant acroos versions 
	# in sage-on-gentoo. This fixes issue #362.
	epatch "${FILESDIR}"/${PN}-6.8-lazy_import_cache.patch

	# Make sure bliss header are found
	sed -i "s:graph.hh:bliss/graph.hh:" sage/graphs/bliss.pyx || die "bliss.pyx not patched"

	############################################################################
	# Fixes to doctests
	############################################################################

	# TODO: should be a patch
	# remove 'local' part
	sed -i "s:\.\.\./local/share/pari:.../share/pari:g" sage/interfaces/gp.py

	# fix all.py
	epatch "${FILESDIR}"/${PN}-6.8-all.py.patch
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

	####################################
	#
	# Fixing problems with documentation
	#
	####################################

	epatch "${FILESDIR}"/${PN}-6.8-misc.patch \
		"${FILESDIR}"/${PN}-6.6-linguas.patch

	# Put singular help file where it is expected
	cp "${WORKDIR}"/Singular/3-1-6/info/singular.hlp doc/
}

python_configure() {
	export SAGE_LOCAL="${EPREFIX}"/usr
	export SAGE_ROOT=`pwd`/..
	export SAGE_SRC=`pwd`
	export SAGE_ETC=`pwd`/bin
	export SAGE_DOC=`pwd`/doc
	export SAGE_DOC_MATHJAX=yes
	export VARTEXFONTS="${T}"/fonts
	export SAGE_VERSION=${PV}
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	# try to fix random sphinx crash during the building of the documentation
	export MPLCONFIGDIR="${T}"/matplotlib
	for option in ${SAGE_USE}; do
		use $option && export WANT_$option="True"
	done
	local mylang
	for lang in ${LANGS} ; do
		use linguas_$lang && mylang+="$lang "
	done
	export LANGUAGES="${mylang}"
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

python_compile_all() {
	distutils-r1_python_compile

	if use html ; then
		${PYTHON} doc/common/builder.py --no-pdf-links all html || die "failed to produce html doc"
	fi
	if use pdf ; then
		export MAKE=make
		${PYTHON} doc/common/builder.py all pdf || die "failed to produce pdf doc"
	fi

}

python_install_all() {
	distutils-r1_python_install_all

	# install cython debugging files if requested
	if use debug; then
		# TODO make it usable if it is installed directly under src rather than src/build
		insinto /usr/share/sage/src/build
		pushd build
		doins -r cython_debug
		popd
	fi

	##############################################
	# install scripts and miscellanous files
	##############################################

	# core scripts which are needed in every case
	pushd bin
	python_foreach_impl python_doscript \
		sage-cleaner \
		sage-eval \
		sage-ipython \
		sage-run \
		sage-num-threads.py \
		sage-rst2txt \
		sage-rst2sws \
		sage-sws2rst

	# COMMAND helper scripts
	python_foreach_impl python_doscript \
		sage-cython \
		sage-notebook \
		sage-run-cython

	# additonal helper scripts
	python_foreach_impl python_doscript sage-preparse sage-startuptime.py

	dobin sage-native-execute sage \
		sage-python sage-version.sh

	# install sage-env under /etc
	insinto /etc
	doins sage-maxima.lisp sage-env sage-banner

	if use testsuite ; then
		# DOCTESTING helper scripts
		python_foreach_impl python_doscript sage-runtests
	fi

	if use debug ; then
		# GNU DEBUGGER helper schripts
		python_foreach_impl python_doscript sage-CSI
		insinto /usr/bin
		doins sage-CSI-helper.py sage-gdb-commands

		# VALGRIND helper scripts
		dobin sage-cachegrind sage-callgrind sage-massif sage-omega \
			sage-valgrind
	fi
	popd

	insinto /usr/share/sage
	doins ../COPYING.txt

	if use X ; then
		doicon "${WORKDIR}"/sage.svg
		domenu "${T}"/sage-sage.desktop
	fi

	insinto /usr/share/sage
	doins -r ext

	####################################
	# Install documentation
	####################################
	docompress -x /usr/share/doc/sage

	insinto /usr/share/doc/sage
	doins doc/singular.hlp
	for lang in ${LANGS} ; do
		use linguas_$lang && doins -r doc/$lang
	done

	insinto /usr/share/doc/sage/common
	# not installing doc build system
	rm doc/common/builder.py
	rm doc/common/custom-sphinx-build.py
	doins -r doc/common/*

	if use html ; then
		cp -r doc/output/html/en/_static doc/output/html/
		for sdir in `find doc/output/html -name _static` ; do
			if [ $sdir != "doc/output/html/_static" ] ; then
				rm -rf $sdir || die "failed to remove $sdir"
				ln -s "${EPREFIX}"/usr/share/doc/sage/html/_static $sdir
			fi
		done
		insinto /usr/share/doc/sage/html
		doins -r doc/output/html/*
	fi

	if use pdf ; then
		insinto /usr/share/doc/sage/pdf
		doins -r doc/output/pdf/*
	fi
}

pkg_preinst() {
	# remove old sage source folder if present
	[[ -d "${ROOT}/usr/share/sage/src/sage" ]] \
		&& rm -rf "${ROOT}/usr/share/sage/src/sage"
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

	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
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
