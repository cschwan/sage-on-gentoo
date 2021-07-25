# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit desktop distutils-r1 flag-o-matic multiprocessing prefix toolchain-funcs git-r3

EGIT_REPO_URI="https://github.com/sagemath/sage.git"
EGIT_BRANCH=develop
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
KEYWORDS=""

DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="https://www.sagemath.org"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
SAGE_USE="bliss meataxe"
IUSE="debug +doc-html doc-pdf jmol latex testsuite X ${SAGE_USE}"
L10N_USEDEP=""
LANGS="ca de en es fr hu it ja pt ru tr"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
	L10N_USEDEP="${L10N_USEDEP}l10n_${X}?,"
done
L10N_USEDEP="${L10N_USEDEP%?}"

RESTRICT="mirror test"

DEPEND="
	~dev-gap/gap-recommended-4.11.1
	dev-libs/gmp:0=
	>=dev-libs/mpc-1.1.0
	>=dev-libs/mpfr-4.0.0
	>=dev-libs/ntl-11.4.3:=
	>=dev-libs/ppl-1.1
	~dev-lisp/ecls-21.2.1
	~dev-python/cypari2-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/cysignals-1.10.3[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.21[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/gmpy-2.1.0_beta5[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.0.0[notebook,${PYTHON_USEDEP}]
	=dev-python/ipywidgets-7*[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/jupyter_jsmol[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.3.1[${PYTHON_USEDEP}]
	dev-python/memory_allocator[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.1[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
	~dev-python/pplpy-0.8.7:=[doc,${PYTHON_USEDEP}]
	>=dev-python/psutil-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-4.0.2[${PYTHON_USEDEP}]
	=media-gfx/threejs-sage-extension-122-r1
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	>=sci-mathematics/arb-2.19.0
	~sci-mathematics/cliquer-1.21
	~sci-mathematics/eclib-20210625[flint]
	=sci-mathematics/flint-2.7*:=[ntl]
	~sci-mathematics/gap-4.11.1
	|| ( =sci-mathematics/giac-1.6.0* =sci-mathematics/giac-1.7.0* )
	>=sci-mathematics/glpk-5.0:0=[gmp]
	~sci-mathematics/gmp-ecm-7.0.4[-openmp]
	>=sci-mathematics/lcalc-1.23-r10[pari]
	<sci-mathematics/lcalc-2.0.0
	~sci-mathematics/lrcalc-1.2
	=sci-mathematics/pari-2.13*
	~sci-mathematics/planarity-3.0.0.5
	>=sci-mathematics/ratpoints-2.1.3
	>=sci-mathematics/rw-0.7
	=sci-mathematics/singular-4.2.0*[readline]
	>=sci-libs/brial-1.2.5
	~sci-libs/givaro-4.1.1
	>=sci-libs/gsl-2.3
	>=sci-libs/iml-1.0.4
	sci-libs/libbraiding
	>=sci-libs/libhomfly-1.0.1
	>=sci-libs/linbox-1.6.3
	sci-libs/m4ri
	sci-libs/m4rie
	>=sci-libs/mpfi-1.5.2
	=sci-libs/pynac-0.7.29-r1[-giac,${PYTHON_USEDEP}]
	>=sci-libs/symmetrica-2.0-r3
	>=sci-libs/zn_poly-0.9
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas
	www-misc/thebe

	bliss? ( >=sci-libs/bliss-0.73 )
	meataxe? ( sci-mathematics/shared_meataxe )
"
BDEPEND="app-portage/gentoolkit
	doc-pdf? ( app-text/texlive[extra,${L10N_USEDEP}] )"

RDEPEND="
	${DEPEND}
	>=dev-lang/R-4.0.4
	>=dev-python/cvxopt-1.2.6[glpk,${PYTHON_USEDEP}]
	>=dev-python/fpylll-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.5[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.8.6[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1.0[${PYTHON_USEDEP}]
	=dev-python/sympy-1.8*[${PYTHON_USEDEP}]
	media-gfx/tachyon[png]
	>=sci-libs/cddlib-094m[tools]
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	>=sci-mathematics/ExportSageNB-3.3
	sci-mathematics/flintqs
	~sci-mathematics/gfan-0.6.2
	>=sci-mathematics/maxima-5.45.0[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/nauty-2.6.1
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-conway_polynomials-0.5
	~sci-mathematics/sage-data-elliptic_curves-0.8
	~sci-mathematics/sage-data-graphs-20210214
	~sci-mathematics/sage-data-polytopes_db-20170220
	!sci-mathematics/sage-notebook
	>=sci-mathematics/sympow-1.018.1
	www-servers/tornado

	jmol? ( sci-chemistry/sage-jmol-bin )
	latex? (
		~dev-tex/sagetex-3.5
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)
	!prefix? ( >=sys-libs/glibc-2.13-r4 )
"
CHECKREQS_DISK_BUILD="8G"

REQUIRED_USE="doc-html? ( jmol l10n_en )
	doc-pdf? ( jmol l10n_en )
	testsuite? ( doc-html jmol )"

PATCHES=(
	"${FILESDIR}"/${PN}-9.2-env.patch
	"${FILESDIR}"/sage_exec-9.3.patch
	"${FILESDIR}"/${PN}-9.3-sources.patch
	"${FILESDIR}"/${PN}-9.3-jupyter.patch
	"${FILESDIR}"/${PN}-9.3-linguas.patch
	"${FILESDIR}"/${PN}-9.3-forcejavatmp.patch
)

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

src_unpack(){
	git-r3_src_unpack

	default
}

python_prepare_all() {
	# replace MAKE by MAKEOPTS in sage-num-threads.py
	sed -i "s:os.environ\[\"MAKE\"\]:os.environ\[\"MAKEOPTS\"\]:g" \
		bin/sage-num-threads.py

	# Turn on debugging capability if required
	if use debug ; then
		sed -i "s:SAGE_DEBUG=\"no\":SAGE_DEBUG=\"yes\":" bin/sage
	fi

	# sage is getting its own system to have scripts that can use either python2 or 3
	# This is of course dangerous and incompatible with Gentoo
	sed -e "s:sage-python:python:g" \
		-e "s:sage-system-python:python:" \
		-i bin/* \
			sage/ext_data/nbconvert/postprocess.py

	# From sage 9.4 the official setup.py is in pkgs/sagemath-standard
	cp ../pkgs/sagemath-standard/setup.py setup.py || die "failed to copy the right setup.py"

	# Remove sage's package management system, git capabilities and associated tests.
	# The patch has to be applied on top of the previously copied setup.py which is why it is not moved to PATCHES.
	eapply "${FILESDIR}"/${PN}-9.4-neutering.patch
	cp -f "${FILESDIR}"/${PN}-7.3-package.py sage/misc/package.py
	rm -f sage/misc/dist.py
	rm -rf sage/dev

	############################################################################
	# sage's configuration variables for Gentoo
	############################################################################

	# sage on gentoo environment variables
	cp -f "${FILESDIR}"/sage_conf.py-9.4 sage/sage_conf.py
	eprefixify sage/sage_conf.py
	# set $PF for the documentation location
	sed -i "s:@GENTOO_PORTAGE_PF@:${PF}:" sage/sage_conf.py
		# Fix finding pplpy documentation with intersphinx
	local pplpyver=`equery -q l -F '$name-$fullversion' pplpy:0`
	sed -i "s:@PPLY_DOC_VERS@:${pplpyver}:" sage/sage_conf.py
	# getting sage_conf from the right spot
	sed -i "s:sage_conf:sage.sage_conf:g" sage/env.py

	# Because lib doesn´t always point to lib64 the following line in cython.py
	# cause very verbose message from the linker in turn triggering doctest failures.
	sed -i "s:SAGE_LOCAL, \"lib\":SAGE_LOCAL, \"$(get_libdir)\":" \
		sage/misc/cython.py

	####################################
	# Bootstrap
	####################################

	einfo "bootstrapping the documentation - be patient"
	SAGE_ROOT="${S}"/.. PATH="${S}/../build/bin:${PATH}" doc/bootstrap || die "cannot bootstrap the documentation"

	distutils-r1_python_prepare_all
}

python_prepare(){
	###############################
	# Link against appropriate pynac
	###############################
	einfo "Adjusting pynac library"
	sed \
		-e "s:libraries = pynac:libraries = pynac_${MULTIBUILD_VARIANT}:" \
		-i sage/libs/pynac/pynac.pxd
}

sage_build_env(){
	export SAGE_ROOT="${S}-${MULTIBUILD_VARIANT}"/..
	export SAGE_SRC="${S}-${MULTIBUILD_VARIANT}"
	export SAGE_DOC_SRC="${S}-${MULTIBUILD_VARIANT}"/doc
}

python_configure_all() {
	export SAGE_DOC="${WORKDIR}"/build_doc
	export SAGE_DOC_MATHJAX=yes
	export VARTEXFONTS="${T}"/fonts
	export SAGE_VERSION=${PV}
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	# try to fix random sphinx crash during the building of the documentation
	export MPLCONFIGDIR="${T}"/matplotlib
	# Avoid spurious message from the gtk backend by making sure it is never tried
	export MPLBACKEND=Agg
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
		"${PYTHON}" sage_docbuild/__main__.py --no-pdf-links all html || die "failed to produce html doc"
	fi

	if use doc-pdf ; then
		DOCS="${WORKDIR}/build_doc/pdf"
		export MAKE="make -j$(makeopts_jobs)"
		"${PYTHON}" sage_docbuild/__main__.py all pdf || die "failed to produce pdf doc"
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

	# Optimize lone postprocess.py script
	python_optimize "${D}/$(python_get_sitedir)/sage/ext_data/nbconvert"
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

	# install env files under /etc
	insinto /etc
	newins ../VERSION.txt sage-version.txt

	if use X ; then
		doicon "${S}"/sage/ext_data/notebook-ipython/logo.svg
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

	# Files needed for generating documentation on the fly
	docompress -x /usr/share/doc/"${PF}"/en /usr/share/doc/"${PF}"/common
	# necessary for sagedoc.py call to sphinxify.
	insinto /usr/share/doc/"${PF}"/common
	doins -r doc/common/themes
	# copy the license in a place that copying can find
	docompress -x /usr/share/doc/"${PF}"
	insinto /usr/share/doc/"${PF}"
	doins ../COPYING.txt

	# install links for the jupyter kernel
	# We have to be careful of removing prefix if present
	PYTHON_SITEDIR=$(python_get_sitedir)
	dosym ../../../../../"${PYTHON_SITEDIR#${EPREFIX}}"/sage/ext_data/notebook-ipython/logo-64x64.png \
		/usr/share/jupyter/kernels/sagemath/logo-64x64.png
	dosym ../../../../../"${PYTHON_SITEDIR#${EPREFIX}}"/sage/ext_data/notebook-ipython/logo.svg \
		/usr/share/jupyter/kernels/sagemath/logo.svg
	if use doc-html; then
		dosym ../../../doc/"${PF}"/html/en /usr/share/jupyter/kernels/sagemath/doc
	fi

	# mpmath 1.2.0+ requires this to work with sage
	echo "MPMATH_SAGE=1" | newenvd - 99"${PN}"
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
	einfo "those listed at: https://sagemath.org/packages/standard/ which are"
	einfo "installed now."
	einfo "There are also some packages of the 'Optional' set (which consists"
	einfo "of the these: https://sagemath.org/packages/optional/) available"
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
