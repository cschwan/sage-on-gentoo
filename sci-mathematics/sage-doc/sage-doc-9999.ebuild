# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="readline,sqlite"

inherit multiprocessing python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sagemath/sage.git"
	EGIT_BRANCH=develop
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/sagemath/sage/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
	S="${WORKDIR}/sage-${PV}"
fi

DESCRIPTION="Build the sage documentation"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc-pdf"
L10N_USEDEP="l10n_en,"
LANGS="ca de es fr hu it ja pt ru tr"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
	L10N_USEDEP="${L10N_USEDEP}l10n_${X}?,"
done
L10N_USEDEP="${L10N_USEDEP%?}"

RESTRICT="mirror test"

# There is a trick to use $PV in python_gen_any_deps
# But it breaks checking with pkgcheck, reports of "missing check for ... "
# may be safely ignored most of the time.
BDEPEND="$(python_gen_any_dep "
	dev-python/sphinx[\${PYTHON_USEDEP}]
	dev-python/furo[\${PYTHON_USEDEP}]
	dev-python/jupyter-sphinx[\${PYTHON_USEDEP}]
	dev-python/sphinx-copybutton[\${PYTHON_USEDEP}]
	dev-python/sphinx-inline-tabs[\${PYTHON_USEDEP}]
	~sci-mathematics/sagemath-standard-${PV}[\${PYTHON_USEDEP},jmol]
	~sci-mathematics/sage_docbuild-${PV}[\${PYTHON_USEDEP}]
	")
	doc-pdf? (
		>=app-text/texlive-2023[extra,luatex,${L10N_USEDEP}]
		>=app-text/texlive-core-2023[xindy]
		media-fonts/freefont
	)
"
RDEPEND="dev-libs/mathjax"
DEPEND="dev-libs/mathjax"

PATCHES=(
	"${FILESDIR}"/${PN}-9.5-neutering.patch
	"${FILESDIR}"/${PN}-10.2-makefile.patch
)

HTML_DOCS="${WORKDIR}/build_doc/html/*"
DOCS=(
	"${WORKDIR}/build_doc/index.html"
	"${S}/src/doc/common"
)

# python_check_deps happilly processes $PV.
python_check_deps() {
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version -b "~sci-mathematics/sagemath-standard-${PV}[${PYTHON_USEDEP},jmol]" &&
	python_has_version -b "~sci-mathematics/sage_docbuild-${PV}[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/furo[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/jupyter-sphinx[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/sphinx-copybutton[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]"
}

src_unpack(){
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi

	default
}

src_prepare(){
	default

	einfo "bootstrapping the documentation - be patient"
	SAGE_ROOT="${S}" PATH="${S}/build/bin:${PATH}" src/doc/bootstrap || die "cannot bootstrap the documentation"

	# remove all the sources outside of src/doc to avoid interferences
	for object in src/* ; do
		if [ $object != "src/doc" ] ; then
			rm -rf $object || die "failed to remove $object"
		fi
	done
}

src_configure(){
	export SAGE_DOC="${WORKDIR}"/build_doc
	export SAGE_DOC_SRC="${S}"/src/doc
	export SAGE_DOC_MATHJAX=yes
	export VARTEXFONTS="${T}"/fonts
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	export SAGE_NUM_THREADS_PARALLEL=$(makeopts_jobs)
	# try to fix random sphinx crash during the building of the documentation
	export MPLCONFIGDIR="${T}"/matplotlib
	# Avoid spurious message from the gtk backend by making sure it is never tried
	export MPLBACKEND=Agg
	local mylang="en "
	for lang in ${LANGS} ; do
		use l10n_$lang && mylang+="$lang "
	done
	export LANGUAGES="${mylang}"
}

src_compile(){
	cd src/doc

	# Needs to be created beforehand or it gets created as a file with the content of _static/plot_directive.css
	mkdir -p "${SAGE_DOC}"/html/en/reference/_static

	# for some reason luatex check whether it can write there.
	# Of course it should fail, but it triggers the sandbox.
	addpredict /var/lib/texmf/m_t_x_t_e_s_t.tmp
	# for some reason opened for write during inventory of reference/plotting(?) - no write happens.
	# This manifest as root
	addpredict "${ESYSROOT}/usr/share/sage/cremona/cremona_mini.db"
	# For some reason java/jmol ignores HOME and uses portage's home as home directory
	# Nothing seem to happen though
	addpredict "${ESYSROOT}/var/lib/portage/home/.java"

	emake doc-html
	if use doc-pdf ; then
		DOCS+=( "${SAGE_DOC}/pdf" )
		emake doc-pdf
	fi
}

src_install(){
	####################################
	# Prepare the documentation for installation
	####################################

	pushd "${WORKDIR}"
	# Prune _static folders
	cp -r build_doc/html/en/_static build_doc/html/ || die "failed to copy _static folder"
	for sdir in `find build_doc -name _static` ; do
		if [ $sdir != "build_doc/html/_static" ] ; then
			rm -rf $sdir || die "failed to remove $sdir"
			ln -rst ${sdir%_static} build_doc/html/_static
		fi
	done
	# Linking to local copy of mathjax folders rather than copying them
	for sobject in $(ls "${ESYSROOT}"/usr/share/mathjax/) ; do
		rm -rf build_doc/html/_static/${sobject} \
			|| die "failed to remove mathjax object $sobject"
		ln -st build_doc/html/_static/ ../../../../mathjax/$sobject
	done
	# prune .buildinfo files, those are internal to sphinx and are not used after building.
	find build_doc -name .buildinfo -delete || die "failed to prune buildinfo files"
	# prune the jupyter_execute folder created by jupyter-sphinx
	rm -rf build_doc/html/en/reference/jupyter_execute
	popd

	docompress -x /usr/share/doc/"${PF}"/common
	einstalldocs

	dosym -r /usr/share/doc/"${PF}" /usr/share/jupyter/kernels/sagemath/doc
}
