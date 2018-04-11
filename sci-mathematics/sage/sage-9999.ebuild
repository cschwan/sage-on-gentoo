# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
PYTHON_REQ_USE="readline,sqlite"

inherit distutils-r1 flag-o-matic multiprocessing prefix toolchain-funcs versionator git-r3

EGIT_REPO_URI="https://github.com/sagemath/sage.git"
EGIT_BRANCH=develop
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
KEYWORDS=""

DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sagemath/sage-icon.tar.bz2"

LANGS="ca de en es fr hu it ja pt ru tr"

LICENSE="GPL-2"
SLOT="0"
SAGE_USE="modular_decomposition bliss libhomfly libbraiding"
IUSE="debug +doc-html doc-pdf jmol latex sagenb testsuite X ${SAGE_USE}"
L10N_USEDEP=""
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
	L10N_USEDEP="${L10N_USEDEP}l10n_${X}=,"
done
L10N_USEDEP="${L10N_USEDEP%?}"

RESTRICT="mirror test"

CDEPEND="dev-libs/gmp:0=
	>=dev-libs/mpfr-4.0.0
	>=dev-libs/mpc-1.1.0
	>=dev-libs/ntl-9.6.2-r1:=
	>=dev-libs/ppl-1.1
	~dev-lisp/ecls-16.1.2
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.13.3-r100[${PYTHON_USEDEP}]
	=dev-python/cython-0.28*[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	~dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/cysignals-1.6.8[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/ipython-5.4.0[notebook,${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	=dev-python/matplotlib-2.1*[${PYTHON_USEDEP}]
	=dev-python/ipywidgets-7*[${PYTHON_USEDEP}]
	>=sci-mathematics/eclib-20170330[flint]
	~sci-mathematics/gmp-ecm-7.0.4[-openmp]
	>=sci-mathematics/flint-2.5.2:=[ntl]
	~sci-libs/givaro-4.0.4
	>=sci-libs/gsl-1.16
	>=sci-libs/iml-1.0.4
	~sci-mathematics/cliquer-1.21
	~sci-libs/libgap-4.8.6
	~sci-libs/linbox-1.5.2[sage]
	~sci-libs/m4ri-20140914
	~sci-libs/m4rie-20150908
	>=sci-libs/mpfi-1.5.2
	~sci-libs/pynac-0.7.16[-giac,${PYTHON_USEDEP}]
	>=sci-libs/symmetrica-2.0-r3
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/giac-1.4.9.45
	>=sci-mathematics/glpk-4.63:0=[gmp]
	>=sci-mathematics/lcalc-1.23-r6[pari]
	>=sci-mathematics/lrcalc-1.2-r1
	>=dev-python/cypari2-1.1.4[${PYTHON_USEDEP}]
	~sci-mathematics/planarity-3.0.0.5
	=sci-libs/brial-1.2*
	=dev-python/sage-brial-1*[${PYTHON_USEDEP}]
	>=sci-mathematics/rw-0.7
	~sci-mathematics/singular-4.1.0_p3[readline]
	>=sci-mathematics/ratpoints-2.1.3
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas
	>=sci-mathematics/arb-2.12.0
	www-misc/thebe
	modular_decomposition? ( sci-libs/modular_decomposition )
	bliss? ( >=sci-libs/bliss-0.73 )
	libhomfly? ( >=sci-libs/libhomfly-1.0.1 )
	libbraiding? ( sci-libs/libbraiding )
	=dev-python/sphinx-1.6*[${PYTHON_USEDEP}]"

DEPEND="${CDEPEND}
	doc-pdf? ( app-text/texlive[extra,${L10N_USEDEP}] )"

RDEPEND="${CDEPEND}
	>=dev-lang/R-3.2.0
	>=dev-python/cvxopt-1.1.8[glpk,${PYTHON_USEDEP}]
	>=dev-python/fpylll-0.2.3[${PYTHON_USEDEP}]
	>=dev-python/mpmath-0.18[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.10[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.0.1-r2[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.3.8[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.1.1-r4[${PYTHON_USEDEP}]
	media-gfx/tachyon[png]
	jmol? ( sci-chemistry/sage-jmol-bin )
	|| ( ~sci-libs/cddlib-094g >=sci-libs/cddlib-094h[tools] )
	>=sci-libs/scipy-0.19.1[${PYTHON_USEDEP}]
	sci-mathematics/flintqs
	~sci-mathematics/gap-4.8.6
	~sci-mathematics/gfan-0.5
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	>=sci-mathematics/ExportSageNB-3.2
	~sci-mathematics/maxima-5.39.0[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/nauty-2.6.1
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/pari-2.10.0_pre20170914
	~sci-mathematics/sage-data-elliptic_curves-0.8
	~sci-mathematics/sage-data-graphs-20161026
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-polytopes_db-20170220
	~sci-mathematics/sage-data-conway_polynomials-0.5
	>=sci-mathematics/sympow-1.018.1
	www-servers/tornado
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
	sagenb? ( >=sci-mathematics/sage-notebook-1.0.1-r3[$(python_gen_usedep 'python2*')] )
	latex? (
		~dev-tex/sage-latex-3.0
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)"

CHECKREQS_DISK_BUILD="8G"

S="${WORKDIR}/${P}/src"

REQUIRED_USE="doc-html? ( l10n_en sagenb )
	doc-pdf? ( sagenb )
	testsuite? ( doc-html jmol )"

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

src_unpack(){
	git-r3_src_unpack

	default
}

python_prepare() {
	#########################################
	#
	# scripts under src/bin and miscellanous files
	#
	#########################################

	# ship our own version of sage-env
	cp "${FILESDIR}"/proto.sage-env bin/sage-env
	eprefixify bin/sage-env
	sed -i "s:@GENTOO_SITEDIR@:$(python_get_sitedir):" bin/sage-env

	# Do not rely on os.environ to get SAGE_SRC
	eapply "${FILESDIR}"/${PN}-8.1-sage-cython.patch

	# make .desktop file
	cat > "${T}"/sage-sage.desktop <<-EOF
		[Desktop Entry]
		Name=Sage Shell
		Type=Application
		Comment=Math software for abstract and numerical computations
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
	eapply "${FILESDIR}"/${PN}-8.2-exec.patch
	eprefixify bin/sage

	# sage is getting its own system to have scripts that can use either python2 or 3
	# This is of course dangerous and incompatible with Gentoo
	sed -e "s:sage-python23:python:" \
		-i bin/*

	# create expected folders under extcode
	mkdir -p ext/sage

	###############################
	#
	# Patches to the sage library
	#
	###############################

	# upgrades compared to base sage
	if has_version ">=sci-libs/cddlib-094h"; then
		eapply "${FILESDIR}"/cddlib-094h.patch
	fi
	# readline 7 breaks the interaction between R and sage.
	# patch should be sage with readline 6. Adopted from Debian
	eapply "${FILESDIR}"/dt-r-no-readline.patch

	# Remove sage's package management system, git capabilities and associated tests
	eapply "${FILESDIR}"/${PN}-8.2-neutering.patch
	cp -f "${FILESDIR}"/${PN}-7.3-package.py sage/misc/package.py
	rm -f sage/misc/dist.py
	rm -rf sage/dev

	# If jmol is not in useflags make tachyon the default 3D plotting engine
	if ! use jmol ; then
		eapply "${FILESDIR}"/${PN}-8.2-tachyon_default.patch
	fi

	###############################
	#
	# Link against appropriate pynac
	#
	###############################

	sed \
		-e "s:libraries = pynac:libraries = pynac_${MULTIBUILD_VARIANT}:" \
		-i sage/libs/pynac/pynac.pxd

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# fix lcalc path
	sed -i "s:libLfunction:Lfunction:g" sage/libs/lcalc/lcalc_sage.h

	# Do not clean up the previous install with setup.py
	# Get headers generated by cython installed and found at runtime and buildtime
	# Also install all appropriate sources alongside python code.
	# get the doc building in the right place and replace relative import to the right location.
	eapply "${FILESDIR}"/${PN}-8.2-sources.patch

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# sage on gentoo env.py
	eapply "${FILESDIR}"/${PN}-8.1-env.patch
	eprefixify sage/env.py
	# fix library path of libSingular
	sed -i "s:lib/libSingular:$(get_libdir)/libSingular:" \
		sage/env.py

	# fix issue #363 where there is bad interaction between MPL build with qt4 support and ecls
	eapply "${FILESDIR}"/${PN}-7.4-qt4_conflict.patch

	# sage-maxima.lisp really belong to /etc
	eapply "${FILESDIR}"/${PN}-8.1-maxima.lisp.patch

	# TODO: should be a patch
	# run maxima with ecl
	sed -i "s:'maxima :'maxima -l ecl :g" \
		sage/interfaces/maxima.py \
		sage/interfaces/maxima_abstract.py

	# finding JmolData.jar in the right place
	sed -i "s:\"jmol\", \"JmolData:\"sage-jmol-bin\", \"lib\", \"JmolData:" sage/interfaces/jmoldata.py

	# Do not get the version of threejs by using sage packaging system
	eapply "${FILESDIR}"/${PN}-8.0-threejs.patch

	# Make sage-inline-fortran useless by having better fortran settings
	sed -i \
		-e "s:--f77exec=sage-inline-fortran:--f77exec=$(tc-getF77):g" \
		-e "s:--f90exec=sage-inline-fortran:--f90exec=$(tc-getFC):g" \
		sage/misc/inline_fortran.py

	# TODO: should be a patch
	# patch lie library path
	sed -i -e "s:/lib/LiE/:/share/lie/:" sage/interfaces/lie.py

	# patching libs/gap/util.pyx so we don't get noise from missing SAGE_LOCAL/gap/latest
	eapply "${FILESDIR}"/${PN}-8.0-libgap.patch

	# The ipython kernel tries to to start a new session via $SAGE_ROOT/sage -python
	# Since we don't have $SAGE_ROOT/sage it fails.
	#See https://github.com/cschwan/sage-on-gentoo/issues/342
	# There are a lot of issue with that file during building and installation.
	# it tries to link in the filesystem in ways that are difficult to support
	# in a global install from a pure python perspective. See also
	# https://github.com/cschwan/sage-on-gentoo/issues/376
	eapply "${FILESDIR}"/${PN}-7.6-jupyter.patch
	touch sage_setup/jupyter/__init__.py

	# Make the lazy_import pickle name versioned with the sage version number
	# rather than the path to the source which is a constant across versions
	# in sage-on-gentoo. This fixes issue #362.
	eapply "${FILESDIR}"/${PN}-6.8-lazy_import_cache.patch

	############################################################################
	# Fixes to doctests
	############################################################################

	# https://trac.sagemath.org/ticket/23748 introduce memory limit for doctests
	# it has a knowck down effect on various doctest in pure Gentoo as well as prefix.
	# Disabling until it is improved
	eapply "${FILESDIR}"/${PN}-8.2-doctest_memory.patch

	# boost 1.62 leads to different results when used in polybori
	# Using debian patch
	# https://anonscm.debian.org/cgit/debian-science/packages/sagemath.git/tree/debian/patches/u1-version-pbori-boost1.62-hashes.patch
	if has_version ">=dev-libs/boost-1.62.0" ; then
		eapply "${FILESDIR}"/pbori-boost1.62-hashes.patch
	fi

	# fix all.py
	eapply "${FILESDIR}"/${PN}-7.2-all.py.patch
	sed -i \
		-e "s:\"lib\",\"python\":\"$(get_libdir)\",\"${EPYTHON}\":" \
		-e "s:\"bin\":\"lib\",\"python-exec\",\"${EPYTHON}\":" sage/all.py

	# Test looking for "/usr/bin/env python" when we are using python-exec
	sed -i \
		-e "s:env python:python-exec2c:" sage/tests/cmdline.py

	# Test looking for "python"
	sed -i \
		-e "s:/python:/${EPYTHON}:" sage/misc/gperftools.py

	# do not test safe python stuff from trac 13579. Needs to be applied after neutering.
	eapply "${FILESDIR}"/${PN}-7.3-safepython.patch

	# 'sage' is not in SAGE_ROOT, but in PATH
	eapply "${FILESDIR}"/${PN}-8.2-ostools.patch

	# Do not check build documentation against the source
	eapply "${FILESDIR}"/${PN}-7.1-sagedoc.patch

	# remove the test trying to pre-compile sage's .py file with python3
	rm sage/tests/py3_syntax.py || die "cannot remove py3_syntax test"

	####################################
	#
	# Fixing problems with documentation
	#
	####################################

	eapply "${FILESDIR}"/${PN}-7.4-misc.patch \
		"${FILESDIR}"/${PN}-7.1-linguas.patch
	# Correct path to mathjax
	eapply "${FILESDIR}"/sage-8.2-mathjax_path.patch
}

sage_build_env(){
	export SAGE_ROOT="${S}-${MULTIBUILD_VARIANT}"/..
	export SAGE_SRC="${S}-${MULTIBUILD_VARIANT}"
	export SAGE_ETC="${S}-${MULTIBUILD_VARIANT}"/bin
	export SAGE_DOC="${S}-${MULTIBUILD_VARIANT}"/build_doc
	export SAGE_DOC_SRC="${S}-${MULTIBUILD_VARIANT}"/doc
}

python_configure_all() {
	export SAGE_LOCAL="${EPREFIX}"/usr
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
		use l10n_$lang && mylang+="$lang "
	done
	export LANGUAGES="${mylang}"
	if use debug; then
		export SAGE_DEBUG=1
	fi
}

python_configure(){
	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

python_compile() {
	sage_build_env

	distutils-r1_python_compile

	if ! python_is_python3; then
		if use doc-html ; then
			"${PYTHON}" sage_setup/docbuild/__main__.py --no-pdf-links all html || die "failed to produce html doc"
		fi
		if use doc-pdf ; then
			export MAKE="make -j$(makeopts_jobs)"
			"${PYTHON}" sage_setup/docbuild/__main__.py all pdf || die "failed to produce pdf doc"
		fi
	fi
}

python_install() {
	sage_build_env

	# Install cython debugging files if requested
	# They are now produced by default
	if ! use debug; then
		rm -rf build/lib/sage/cython_debug || \
			die "failed to remove cython debugging information."
	fi

	distutils-r1_python_install

	##############################################
	# install scripts and miscellanous files
	##############################################

	# core scripts which are needed in every case
	pushd bin
	python_doscript \
		sage-cleaner \
		sage-eval \
		sage-ipython \
		sage-run \
		sage-num-threads.py \
		sage-rst2txt \
		sage-rst2sws \
		sage-sws2rst

	# COMMAND helper scripts
	python_doscript \
		sage-cython \
		sage-notebook \
		sage-run-cython \
		math-readline

	# additonal helper scripts
	python_doscript sage-preparse sage-startuptime.py

	if use testsuite ; then
		# DOCTESTING helper scripts
		python_doscript sage-runtests
	fi
	popd

	if use testsuite ; then
		# install extra testfiles under sage/doctests
		local testspath="${D}"/$(python_get_sitedir)/sage/doctest/tests
		mkdir -p "${testspath}"
		cp sage/doctest/tests/* "${testspath}"/
	fi

	if ! python_is_python3; then
	####################################
	# Install documentation
	####################################
		docompress -x /usr/share/doc/sage

		# necessary for sagedoc.py call to sphinxify in sagenb for now.
		insinto /usr/share/doc/sage/en/introspect
		doins -r doc/en/introspect/*
		insinto /usr/share/doc/sage/common
		doins -r doc/common/*
		doins sage_setup/docbuild/ext/sage_autodoc.py
		doins sage_setup/docbuild/ext/inventory_builder.py
		doins sage_setup/docbuild/ext/multidocs.py

		# rst files are installed as rst.txt which prevents doctesting
		pushd "${ED}"
		for i in `find usr/share/doc/sage -name \*.rst.txt`; do
			mv "${i}" "${i%.txt}"
		done
		popd

		if use doc-html ; then
			# Prune _static folders
			cp -r build_doc/html/en/_static build_doc/html/ || die "failed to copy _static folder"
			for sdir in `find build_doc/html -name _static` ; do
				if [ $sdir != "build_doc/html/_static" ] ; then
					rm -rf $sdir || die "failed to remove $sdir"
					ln -rst ${sdir%_static} build_doc/html/_static
				fi
			done
			# Linking to local copy of mathjax folders rather than copying them
			local mathjax_folders="config extensions fonts jax localization unpacked"
			for sdir in ${mathjax_folders} ; do
				rm -rf build_doc/html/_static/${sdir} \
					|| die "failed to remove mathjax folder $sdir"
				ln -st build_doc/html/_static/ ../../../../mathjax/$sdir
			done
			# Work around for issue #402 until I understand where it comes from
			for pyfile in `find build_doc/html -name \*.py` ; do
				rm -rf "${pyfile}" || die "fail to to remove $pyfile"
				rm -rf "${pyfile/%.py/.pdf}" "${pyfile/%.py/png}"
			done
			# restore .rst.txt file to .rst
			for i in `find build_doc -name \*.rst.txt`; do
				mv "${i}" "${i%.txt}"
			done
			# proceed with install
			insinto /usr/share/doc/sage/html
			doins -r build_doc/html/*
			dosym ../../../doc/sage/html/en /usr/share/jupyter/kernels/sagemath/doc
		fi

		if use doc-pdf ; then
			insinto /usr/share/doc/sage/pdf
			doins -r build_doc/pdf/*
		fi
	fi
}

python_install_all(){
	distutils-r1_python_install_all

	pushd bin

	dobin sage-native-execute sage \
		sage-python sage-version.sh

	# install sage-env under /etc
	insinto /etc
	doins sage-maxima.lisp sage-env
	newins ../../VERSION.txt sage-version.txt

	if use debug ; then
		# GNU DEBUGGER helper schripts
		insinto /usr/bin
		doins sage-gdb-commands

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

	# install links and kernel for jupyter install
	dodir /usr/share/jupyter/kernels/sagemath
	insinto /usr/share/jupyter/kernels/sagemath
	doins build/spec/kernels/sagemath/kernel.json
	dodir /usr/share/jupyter/nbextensions
	ln -sf "${EPREFIX}/usr/share/mathjax" "${ED}"/usr/share/jupyter/nbextensions/mathjax || die "die creating mathjax simlink"
	ln -sf "${EPREFIX}/usr/share/jsmol" "${ED}"/usr/share/jupyter/nbextensions/jsmol || die "die creating jsmol simlink"
	dosym ../../../sage/ext/notebook-ipython/logo-64x64.png /usr/share/jupyter/kernels/sagemath/logo-64x64.png
	dosym ../../../sage/ext/notebook-ipython/logo.svg /usr/share/jupyter/kernels/sagemath/logo.svg
}

pkg_preinst() {
	# remove old sage source folder if present
	[[ -d "${ROOT}/usr/share/sage/src/sage" ]] \
		&& rm -rf "${ROOT}/usr/share/sage/src/sage"
	# remove old links if present
	rm -rf "${EROOT}"/usr/share/jupyter/nbextensions/*
	rm -rf "${EROOT}"/usr/share/jupyter/kernels/sagemath/*
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

	if ! use doc-html ; then
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
