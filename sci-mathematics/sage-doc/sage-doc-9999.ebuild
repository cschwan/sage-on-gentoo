# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="readline,sqlite"

inherit python-any-r1 git-r3

EGIT_REPO_URI="https://github.com/sagemath/sage.git"
EGIT_BRANCH=develop
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
KEYWORDS=""

DESCRIPTION="Build the sage documentation"
HOMEPAGE="https://www.sagemath.org"
S="${WORKDIR}/${P}"

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

BDEPEND="$(python_gen_any_dep '
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/furo[${PYTHON_USEDEP}]
	dev-python/jupyter_sphinx[${PYTHON_USEDEP}]
	~sci-mathematics/sage-9999[${PYTHON_USEDEP},jmol]
	~sci-mathematics/sage_docbuild-9999[${PYTHON_USEDEP}]
	>=dev-python/cvxopt-1.2.6[glpk,${PYTHON_USEDEP}]
	>=dev-python/fpylll-0.5.9[${PYTHON_USEDEP}]
	>=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.6[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1.0[${PYTHON_USEDEP}]
	~dev-python/sympy-1.11.1[${PYTHON_USEDEP}]
	>=sci-mathematics/ExportSageNB-3.3[${PYTHON_USEDEP}]
	')
	media-gfx/tachyon[png]
	>=sci-libs/cddlib-094m[tools]
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	sci-mathematics/flintqs
	~sci-mathematics/gfan-0.6.2
	>=sci-mathematics/maxima-5.45.1-r3[ecls]
	<sci-mathematics/maxima-5.46.0
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
	doc-pdf? ( app-text/texlive[extra,${L10N_USEDEP}] )"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-9.5-neutering.patch
	"${FILESDIR}"/${PN}-9.7-makefile_and_parallel.patch
	"${FILESDIR}"/gap-4.12.2.patch
)

HTML_DOCS="${WORKDIR}/build_doc/html/*"
DOCS=(
	"${WORKDIR}/build_doc/index.html"
	"${S}/src/doc/common"
)

# for some reason opened for write during inventory of reference/plotting(?) - no write happens.
# This manifest as root
addpredict "${ESYSROOT}/usr/share/sage/cremona/cremona_mini.db"

python_check_deps() {
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version -b "~sci-mathematics/sage-9999[${PYTHON_USEDEP},jmol]" &&
	python_has_version -b "~sci-mathematics/sage_docbuild-9999[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/furo[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/jupyter_sphinx[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/cvxopt-1.2.6[glpk,${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/fpylll-0.5.9[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/networkx-2.6[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/pexpect-4.2.1[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/scipy-1.1.0[${PYTHON_USEDEP}]" &&
	python_has_version -b "~dev-python/sympy-1.11.1[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=sci-mathematics/ExportSageNB-3.3[${PYTHON_USEDEP}]"
}

src_unpack(){
	git-r3_src_unpack

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
	# prune the jupyter_execute folder created by jupyter_sphinx
	rm -rf build_doc/html/en/reference/jupyter_execute

	# Replace full "build" path to html index in pdf doc
	if use doc-pdf ; then
		sed -e "s:${WORKDIR}/build_doc:${ESYSROOT}/usr/share/doc/${P}:g" -i \
			build_doc/pdf/en/reference/index.html
	fi
	popd

	docompress -x /usr/share/doc/"${PF}"/common
	einstalldocs

	dosym -r /usr/share/doc/"${PF}" /usr/share/jupyter/kernels/sagemath/doc
}
