# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
PYTHON_REQ_USE="readline,sqlite"

inherit desktop distutils-r1 flag-o-matic multiprocessing prefix toolchain-funcs

KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="https://github.com/sagemath/sage/archive/${PV}.tar.gz -> ${P}.tar.gz
	mirror://sagemath/sage-icon.tar.bz2
	doc-html-bin? ( mirror://sagemath/${P}-doc-html.tar.xz )
	doc-pdf-bin? ( mirror://sagemath/${P}-doc-pdf.tar.xz )"

LANGS="ca de en es fr hu it ja pt ru tr"

LICENSE="GPL-2"
SLOT="0"
SAGE_USE="bliss"
IUSE="debug doc-html +doc-html-bin doc-pdf doc-pdf-bin jmol latex sagenb testsuite X ${SAGE_USE}"
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
	>=dev-python/numpy-1.16.1[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.1[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/cysignals-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.4.0[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/ipython-5.8.0[notebook,${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	=dev-python/matplotlib-2.2*[${PYTHON_USEDEP}]
	=dev-python/ipywidgets-7*[${PYTHON_USEDEP}]
	>=dev-python/gmpy-2.1.0_beta1[${PYTHON_USEDEP}]
	>=dev-python/pplpy-0.8.4:=[doc,${PYTHON_USEDEP}]
	~sci-mathematics/eclib-20190226[flint]
	~sci-mathematics/gmp-ecm-7.0.4[-openmp]
	>=sci-mathematics/flint-2.5.2:=[ntl]
	~sci-libs/givaro-4.0.4
	>=sci-libs/gsl-2.3
	>=sci-libs/iml-1.0.4
	~sci-mathematics/cliquer-1.21
	~sci-libs/linbox-1.5.2
	~sci-libs/m4ri-20140914
	~sci-libs/m4rie-20150908
	>=sci-libs/mpfi-1.5.2
	~sci-libs/pynac-0.7.24[-giac,${PYTHON_USEDEP}]
	>=sci-libs/symmetrica-2.0-r3
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/gap-4.10.1[recommended_pkgs]
	>=sci-mathematics/giac-1.5.0.43
	>=sci-mathematics/glpk-4.63:0=[gmp]
	>=sci-mathematics/lcalc-1.23-r10[pari]
	>=sci-mathematics/lrcalc-1.2-r1
	>=dev-python/cypari2-2.1.0[${PYTHON_USEDEP}]
	=sci-mathematics/pari-2.11*
	~sci-mathematics/planarity-3.0.0.5
	>=sci-libs/brial-1.2.5
	=dev-python/sage-brial-1*[${PYTHON_USEDEP}]
	>=sci-mathematics/rw-0.7
	~sci-mathematics/singular-4.1.1_p2[readline]
	>=sci-mathematics/ratpoints-2.1.3
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	~media-gfx/threejs-sage-extension-100
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas
	~sci-mathematics/arb-2.16.0
	www-misc/thebe
	>=sci-libs/libhomfly-1.0.1
	sci-libs/libbraiding
	bliss? ( >=sci-libs/bliss-0.73 )
	>=dev-python/sphinx-1.8.5[${PYTHON_USEDEP}]
	<dev-python/sphinx-2.0.0"

DEPEND="${CDEPEND}
	app-portage/gentoolkit
	doc-pdf? ( app-text/texlive[extra,${L10N_USEDEP}] )"

RDEPEND="${CDEPEND}
	>=dev-lang/R-3.2.0
	>=dev-python/cvxopt-1.2.2[glpk,${PYTHON_USEDEP}]
	>=dev-python/fpylll-0.2.3[${PYTHON_USEDEP}]
	>=dev-python/mpmath-0.18[${PYTHON_USEDEP}]
	~dev-python/networkx-2.2[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.8.0[${PYTHON_USEDEP}]
	<dev-python/rpy-2.9.0
	~dev-python/sympy-1.4[${PYTHON_USEDEP}]
	media-gfx/tachyon[png]
	jmol? ( sci-chemistry/sage-jmol-bin )
	>=sci-libs/cddlib-094j[tools]
	>=sci-libs/scipy-1.1.0[${PYTHON_USEDEP}]
	sci-mathematics/flintqs
	~sci-mathematics/gfan-0.6.2
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	>=sci-mathematics/ExportSageNB-3.2
	>=sci-mathematics/maxima-5.42.2[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/nauty-2.6.1
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-elliptic_curves-0.8
	~sci-mathematics/sage-data-graphs-20161026
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-polytopes_db-20170220
	~sci-mathematics/sage-data-conway_polynomials-0.5
	>=sci-mathematics/sympow-1.018.1
	www-servers/tornado
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
	sagenb? ( >=sci-mathematics/sage-notebook-1.1.2[$(python_gen_usedep 'python2*')] )
	latex? (
		~dev-tex/sage-latex-3.2
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)"

CHECKREQS_DISK_BUILD="8G"

S="${WORKDIR}/${P}/src"

REQUIRED_USE="doc-html? ( l10n_en sagenb )
	doc-pdf? ( sagenb )
	testsuite? ( || ( doc-html doc-html-bin ) )
	doc-html-bin? ( !doc-html !doc-pdf l10n_en )
	doc-pdf-bin? ( !doc-html !doc-pdf l10n_en )"

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

python_prepare_all() {
	#########################################
	#
	# scripts under src/bin and miscellanous files
	#
	#########################################

	# Do not rely on os.environ to get SAGE_SRC
	eapply "${FILESDIR}"/${PN}-8.1-sage-cython.patch

	# Remove useless SAGE_LOCAL
	eapply "${FILESDIR}"/${PN}-bin-8.7.patch

	# replace MAKE by MAKEOPTS in sage-num-threads.py
	sed -i "s:os.environ\[\"MAKE\"\]:os.environ\[\"MAKEOPTS\"\]:g" \
		bin/sage-num-threads.py

	# Replace SAGE_EXTCODE with the installation location
	sed -i "s:\$SAGE_EXTCODE:${EPREFIX}/usr/share/sage/ext:g" \
		bin/sage-ipynb2rst \
		bin/sage-valgrind

	# ship our simplified sage shell script
	# Now including sage-env as of 8.7.beta5+
	cp "${FILESDIR}"/sage-exec bin/sage
	eprefixify bin/sage
	if use debug ; then
		sed -i "s:SAGE_DEBUG=\"no\":SAGE_DEBUG=\"yes\":" bin/sage
	fi

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

	# Remove sage's package management system, git capabilities and associated tests
	eapply "${FILESDIR}"/${PN}-8.8-neutering.patch
	cp -f "${FILESDIR}"/${PN}-7.3-package.py sage/misc/package.py
	rm -f sage/misc/dist.py
	rm -rf sage/dev

	# If jmol is not in useflags make tachyon the default 3D plotting engine
	if ! use jmol ; then
		eapply "${FILESDIR}"/${PN}-8.5-tachyon_default.patch
	fi

	# Because lib doesn´t always point to lib64 the following line in cython.py
	# cause very verbose message from the linker in turn triggering doctest failures.
	sed -i "s:SAGE_LOCAL, \"lib\":SAGE_LOCAL, \"$(get_libdir)\":" \
		sage/misc/cython.py

	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# fix lcalc path
	sed -i "s:libLfunction:Lfunction:g" sage/libs/lcalc/lcalc_sage.h

	# Do not clean up the previous install with setup.py
	# Get headers generated by cython installed and found at runtime and buildtime
	# Also install all appropriate sources alongside python code.
	# get the doc building in the right place and replace relative import to the right location.
	eapply "${FILESDIR}"/${PN}-8.7-sources.patch

	# Mirroring the the fact that lib is not a link to lib64 anymore in the build system
	sed -i "s:SAGE_LOCAL, \"lib\":SAGE_LOCAL, \"$(get_libdir)\":" setup.py

	# upstream patch for deprecated sphinx function
	eapply "${FILESDIR}"/trac27971.patch

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# sage on gentoo env.py
	eapply "${FILESDIR}"/${PN}-8.7-env.patch
	# set $PF for the documentation location
	sed -i "s:@GENTOO_PORTAGE_PF@:${PF}:" sage/env.py

	# sage-maxima.lisp really belong to /etc
	eapply "${FILESDIR}"/${PN}-8.3-maxima.lisp.patch

	# TODO: should be a patch
	# run maxima with ecl
	sed -i "s:'maxima :'maxima -l ecl :g" \
		sage/interfaces/maxima.py \
		sage/interfaces/maxima_abstract.py

	# Do not get the version of threejs by using sage packaging system
	eapply "${FILESDIR}"/${PN}-8.8-threejs.patch

	# Make sage-inline-fortran useless by having better fortran settings
	sed -i \
		-e "s:--f77exec=sage-inline-fortran:--f77exec=$(tc-getF77):g" \
		-e "s:--f90exec=sage-inline-fortran:--f90exec=$(tc-getFC):g" \
		sage/misc/inline_fortran.py

	# patch lie library path
	eapply "${FILESDIR}"/${PN}-8.8-lie-interface.patch

	# The ipython kernel tries to to start a new session via $SAGE_ROOT/sage -python
	# Since we don't have $SAGE_ROOT/sage it fails.
	# See https://github.com/cschwan/sage-on-gentoo/issues/342
	# Also some symlinks are created to absolute paths that don't exist yet.
	eapply "${FILESDIR}"/${PN}-8.8-jupyter.patch

	############################################################################
	# Fixes to doctests
	############################################################################

	# Remove all SAGE_LOCAL in control.py
	sed -i \
		"s:\$SAGE_LOCAL:${EPREFIX}/usr:g" \
		sage/doctest/control.py

	# fix all.py
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
	eapply "${FILESDIR}"/${PN}-8.7-safepython.patch

	# remove the test trying to pre-compile sage's .py file with python3
	rm sage/tests/py3_syntax.py || die "cannot remove py3_syntax test"

	####################################
	#
	# Documentation specific patch
	#
	####################################

	eapply "${FILESDIR}"/${PN}-8.3-pdfbuild.patch
	# Fix finding pplpy documentation with intersphinx
	local pplpyver=`equery -q l -F '$name-$fullversion' pplpy:0`
	sed -i \
		"s:SAGE_SHARE, 'doc', 'pplpy':SAGE_LOCAL, 'share', 'doc', '${pplpyver}', 'html':" \
		sage/env.py
	# support linguas so only requested languages are installed
	eapply "${FILESDIR}"/${PN}-7.1-linguas.patch
	# Correct path to mathjax
	eapply "${FILESDIR}"/${PN}-8.2-mathjax_path.patch

	#####################################
	#
	# Putting binary documentation in place if used.
	#
	#####################################

	if use doc-html-bin ; then
		HTML_DOCS="${WORKDIR}/build_doc/html/*"
		mkdir -p "${WORKDIR}"/build_doc/html
		# Don't forget to also copy the _static folder in place
		cp -r "${WORKDIR}"/html/_static "${WORKDIR}"/build_doc/html/
		for lang in ${LANGS} ; do
			use l10n_$lang && cp -r "${WORKDIR}"/html/${lang} "${WORKDIR}"/build_doc/html/
		done
	fi

	if use doc-pdf-bin ; then
		DOCS="${WORKDIR}/build_doc/pdf"
		mkdir -p "${WORKDIR}"/build_doc/pdf
		for lang in ${LANGS} ; do
			use l10n_$lang && cp -r "${WORKDIR}"/pdf/${lang} "${WORKDIR}"/build_doc/pdf/
		done
	fi

	distutils-r1_python_prepare_all
}

python_prepare(){
	###############################
	#
	# Link against appropriate pynac
	#
	###############################
	einfo "Adjusting pynac library"
	sed \
		-e "s:libraries = pynac:libraries = pynac_${MULTIBUILD_VARIANT}:" \
		-i sage/libs/pynac/pynac.pxd
}

sage_build_env(){
	export SAGE_ROOT="${S}-${MULTIBUILD_VARIANT}"/..
	export SAGE_SRC="${S}-${MULTIBUILD_VARIANT}"
	export SAGE_ETC="${S}-${MULTIBUILD_VARIANT}"/bin
	export SAGE_DOC_SRC="${S}-${MULTIBUILD_VARIANT}"/doc
}

python_configure_all() {
	export SAGE_LOCAL="${EPREFIX}"/usr
	export SAGE_DOC="${WORKDIR}"/build_doc
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
}

python_compile_all(){
	if use doc-html ; then
		HTML_DOCS="${WORKDIR}/build_doc/html/*"
		"${PYTHON}" sage_setup/docbuild/__main__.py --no-pdf-links all html || die "failed to produce html doc"
	fi

	if use doc-pdf ; then
		DOCS="${WORKDIR}/build_doc/pdf"
		export MAKE="make -j$(makeopts_jobs)"
		"${PYTHON}" sage_setup/docbuild/__main__.py all pdf || die "failed to produce pdf doc"
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
}

python_install_all(){
	if use doc-html ; then
		####################################
		# Prepare the html documentation for installation
		####################################

		pushd "${WORKDIR}"
		# Prune _static folders
		cp -r build_doc/html/en/_static build_doc/html/ || die "failed to copy _static folder"
		for sdir in `find build_doc/html -name _static` ; do
			if [ $sdir != "build_doc/html/_static" ] ; then
				rm -rf $sdir || die "failed to remove $sdir"
				ln -rst ${sdir%_static} build_doc/html/_static
			fi
		done
		# Linking to local copy of mathjax folders rather than copying them
		for sobject in $(ls "${EPREFIX}"/usr/share/mathjax/) ; do
			rm -rf build_doc/html/_static/${sobject} \
				|| die "failed to remove mathjax object $sobject"
			ln -st build_doc/html/_static/ ../../../../mathjax/$sobject
		done
		# Work around for issue #402 until I understand where it comes from
		for pyfile in `find build_doc/html -name \*.py` ; do
			rm -rf "${pyfile}" || die "fail to to remove $pyfile"
			rm -rf "${pyfile/%.py/.pdf}" "${pyfile/%.py/.png}"
			rm -rf "${pyfile/%.py/.hires.png}" "${pyfile/%.py/.html}"
		done
		# restore .rst.txt file to .rst
		for i in `find build_doc -name \*.rst.txt`; do
			mv "${i}" "${i%.txt}"
		done
		popd
	fi

	distutils-r1_python_install_all

	pushd bin

	dobin sage-native-execute sage sage-ipynb2rst \
		sage-python sage-version.sh

	# install env files under /etc
	insinto /etc
	doins sage-maxima.lisp
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

	if use X ; then
		doicon "${S}"/ext/notebook-ipython/logo.svg
		newmenu - sage-sage.desktop <<-EOF
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
	fi

	insinto /usr/share/sage
	doins -r ext

	# Files needed for generating documentation on the fly
	docompress -x /usr/share/doc/"${PF}"/en /usr/share/doc/"${PF}"/common
	# necessary for sagedoc.py call to sphinxify.
	insinto /usr/share/doc/"${PF}"/en/introspect
	doins -r doc/en/introspect/*
	insinto /usr/share/doc/"${PF}"/common
	doins -r doc/common/*
	doins sage_setup/docbuild/ext/sage_autodoc.py
	doins sage_setup/docbuild/ext/inventory_builder.py
	doins sage_setup/docbuild/ext/multidocs.py
	# copy the license in a place that copying can find
	docompress -x /usr/share/doc/"${PF}"
	insinto /usr/share/doc/"${PF}"
	doins ../COPYING.txt

	# install links for the jupyter kernel
	dosym ../../../sage/ext/notebook-ipython/logo-64x64.png /usr/share/jupyter/kernels/sagemath/logo-64x64.png
	dosym ../../../sage/ext/notebook-ipython/logo.svg /usr/share/jupyter/kernels/sagemath/logo.svg
	if use doc-html; then
		dosym ../../../doc/"${PF}"/html/en /usr/share/jupyter/kernels/sagemath/doc
	fi
}

pkg_preinst() {
	# remove old sage source folder if present
	[[ -d "${ROOT}/usr/share/sage/src/sage" ]] \
		&& rm -rf "${ROOT}/usr/share/sage/src/sage"
	# remove old links if present
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
		if ! use doc-html-bin ; then
			ewarn "You haven't requested the html documentation."
			ewarn "The html version of the sage manual won't be available in the sage notebook."
		fi
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
