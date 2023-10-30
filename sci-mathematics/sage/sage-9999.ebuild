# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit desktop distutils-r1 multiprocessing toolchain-funcs

MY_PN="sagemath-standard"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3 sage-git
	EGIT_REPO_URI="https://github.com/sagemath/sage.git"
else
	inherit pypi
	SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}")"
	KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x64-macos"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="https://www.sagemath.org"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +doc jmol latex test X"

RESTRICT="mirror"

DEPEND="
	~dev-gap/gap-recommended-4.12.2
	dev-libs/gmp:0=
	>=dev-libs/mpc-1.1.0
	>=dev-libs/mpfr-4.0.0
	>=dev-libs/ntl-11.4.3:=
	>=dev-libs/ppl-1.1
	~dev-lisp/ecl-21.2.1
	>=dev-python/cypari2-2.1.4[${PYTHON_USEDEP}]
	>=dev-python/cysignals-1.11.2-r1[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	>=dev-python/gmpy-2.1.0_beta5[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.0.0[notebook,${PYTHON_USEDEP}]
	dev-python/ipywidgets[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	~dev-python/jupyter-jsmol-2022.1.0[${PYTHON_USEDEP}]
	dev-python/lrcalc[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
	dev-python/memory-allocator[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.1[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
	dev-python/pplpy[doc,${PYTHON_USEDEP}]
	dev-python/primecountpy[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-5.2.0[${PYTHON_USEDEP}]
	~media-gfx/threejs-sage-extension-122
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	>=sci-mathematics/arb-2.19.0
	sci-mathematics/cliquer
	sci-mathematics/eclib:=[flint]
	>=sci-mathematics/flint-2.7.1:=[ntl]
	~sci-mathematics/gap-4.12.2
	>=sci-mathematics/giac-1.9.0
	>=sci-mathematics/glpk-5.0:0=[gmp]
	~sci-mathematics/gmp-ecm-7.0.5[-openmp]
	=sci-mathematics/lcalc-2.0*
	>=sci-mathematics/pari-2.15.2
	<sci-mathematics/pari-2.16.0
	=sci-mathematics/planarity-3.0*
	>=sci-mathematics/rw-0.7
	~sci-mathematics/sage_setup-${PV}[${PYTHON_USEDEP}]
	~sci-mathematics/sage-conf-${PV}[${PYTHON_USEDEP}]
	>=sci-mathematics/singular-4.3.2[readline]
	>=sci-libs/brial-1.2.10
	~sci-libs/givaro-4.1.1
	>=sci-libs/gsl-2.3
	>=sci-libs/iml-1.0.4
	sci-libs/libbraiding
	>=sci-libs/libhomfly-1.0.1
	>=sci-libs/linbox-1.6.3
	sci-libs/m4ri
	sci-libs/m4rie
	>=sci-libs/mpfi-1.5.2
	>=sci-libs/symmetrica-2.0-r3
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas

	test? ( ~sci-mathematics/sage_docbuild-${PV}[${PYTHON_USEDEP}] )
"

RDEPEND="
	${DEPEND}
	>=dev-lang/R-4.0.4
	>=dev-python/cvxopt-1.2.6[glpk,${PYTHON_USEDEP}]
	>=dev-python/fpylll-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.6[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/rpy-3.5.7[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1.0[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	media-gfx/tachyon[png]
	>=sci-libs/cddlib-094m[tools]
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	>=sci-mathematics/ExportSageNB-3.3[${PYTHON_USEDEP}]
	~sci-mathematics/gfan-0.6.2
	>=sci-mathematics/maxima-5.46.0[ecl]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/nauty-2.6.1
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-conway_polynomials-0.5
	~sci-mathematics/sage-data-elliptic_curves-0.8
	~sci-mathematics/sage-data-graphs-20210214
	~sci-mathematics/sage-data-polytopes_db-20170220
	>=sci-mathematics/sympow-1.018.1
	dev-python/tornado

	jmol? ( sci-chemistry/sage-jmol-bin )
"

BDEPEND=">=dev-python/cython-3.0.0[${PYTHON_USEDEP}]"

PDEPEND="
	doc? ( ~sci-mathematics/sage-doc-${PV} )
	latex? (
		~dev-tex/sagetex-3.6.1
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)
"

CHECKREQS_DISK_BUILD="8G"

RESTRICT="!test? ( test )"

REQUIRED_USE="doc? ( jmol )
	test? ( jmol )"

PATCHES=(
	"${FILESDIR}"/${PN}-9.2-env.patch
	"${FILESDIR}"/sage_exec-9.3.patch
	"${FILESDIR}"/${PN}-9.3-forcejavatmp.patch
	"${FILESDIR}"/${PN}-10.1-neutering.patch
	"${FILESDIR}"/${PN}-9.8-build_ext.patch
)

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

python_prepare_all() {
	if [[ ${PV} == 9999 ]]; then
		sage-git_src_prepare "${MY_PN}"
	fi

	distutils-r1_python_prepare_all

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

	# Remove sage's package management system, git capabilities and associated tests.
	cp -f "${FILESDIR}"/${PN}-10.1-package.py sage/misc/package.py
	rm -f sage/misc/dist.py
	rm -rf sage/dev

	# Because lib doesn´t always point to lib64 the following line in cython.py
	# cause very verbose message from the linker in turn triggering doctest failures.
	sed -i "s:SAGE_LOCAL, \"lib\":SAGE_LOCAL, \"$(get_libdir)\":" \
		sage/misc/cython.py
}

python_configure_all() {
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	# Needed for cython-3 for now
	export SAGE_DEBUG=no
}

python_install() {
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

python_install_all() {
	distutils-r1_python_install_all

	# install license - uncompressed as it can be read.
	docompress -x /usr/share/doc/"${PF}"
	newdoc LICENSE.txt COPYING.txt

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

	# install links for the jupyter kernel
	# We have to be careful of removing prefix if present
	PYTHON_SITEDIR=$(python_get_sitedir)
	dosym ../../../../.."${PYTHON_SITEDIR#${ESYSROOT}}"/sage/ext_data/notebook-ipython/logo-64x64.png \
		/usr/share/jupyter/kernels/sagemath/logo-64x64.png
	dosym ../../../../.."${PYTHON_SITEDIR#${ESYSROOT}}"/sage/ext_data/notebook-ipython/logo.svg \
		/usr/share/jupyter/kernels/sagemath/logo.svg
}

python_test() {
	SAGE_DOC_SRC="${S}/doc" \
		sage -tp $(makeopts_jobs) --installed --long --baseline-stats-path "${FILESDIR}"/${PN}-9.6-testfailures.json || die
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

	einfo ""
	einfo "* Displaying plots *"
	einfo "if you want sage to display plots while working from a terminal,"
	einfo "you should make sure that matplotlib is installed with at least"
	einfo "one graphical backend such as gtk3 or qt5."

	einfo ""
	einfo "To test a Sage installation with 4 parallel processes run the following command:"
	einfo ""
	einfo "  sage -tp 4 --installed"
	einfo ""
	einfo "Note that testing Sage may take more than an hour depending on your"
	einfo "processor(s). You _will_ see failures but many of them are harmless"
	einfo "such as version mismatches and numerical noise. Since Sage is"
	einfo "changing constantly we do not maintain an up-to-date list of known"
	einfo "failures."

	if ! use doc ; then
		ewarn "You haven't requested the documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
		ewarn "It can still be installed by building sage-doc separately."
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
