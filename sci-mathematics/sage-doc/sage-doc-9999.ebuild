# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="readline,sqlite"

inherit python-any-r1 multiprocessing git-r3

EGIT_REPO_URI="https://github.com/vbraun/sage.git"
EGIT_BRANCH=develop
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
KEYWORDS=""

DESCRIPTION="Build the sage documentation"
HOMEPAGE="https://www.sagemath.org"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="+doc-html doc-pdf"
L10N_USEDEP=""
LANGS="ca de en es fr hu it ja pt ru tr"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
	L10N_USEDEP="${L10N_USEDEP}l10n_${X}?,"
done
L10N_USEDEP="${L10N_USEDEP%?}"

RESTRICT="mirror test"

BDEPEND="$(python_gen_any_dep '
	>=dev-python/sphinx-4.1.0[${PYTHON_USEDEP}]
	>=sci-mathematics/sage-9.5[${PYTHON_USEDEP}]
	')
	doc-pdf? ( app-text/texlive[extra,${L10N_USEDEP}] )"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-9.5-neutering.patch
	"${FILESDIR}"/${PN}-9.5-makefile.patch
)

python_check_deps() {
	has_version ">=dev-python/sphinx-4.1.0[${PYTHON_USEDEP}]" &&
	has_version ">=sci-mathematics/sage-9.5[${PYTHON_USEDEP}]"
}

src_unpack(){
	git-r3_src_unpack

	default
}

src_prepare(){
	einfo "bootstrapping the documentation - be patient"
	SAGE_ROOT="${S}" PATH="${S}/build/bin:${PATH}" src/doc/bootstrap || die "cannot bootstrap the documentation"

	# remove all the sources outside of src/doc to avoid interferences
	for object in src/* ; do
		if [ $object != "src/doc" ] ; then
			rm -rf $object || die "failed to remove $object"
		fi
	done

	default
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
	local mylang
	for lang in ${LANGS} ; do
		use l10n_$lang && mylang+="$lang "
	done
	export LANGUAGES="${mylang}"
}

src_compile(){
	cd src/doc

	# Needs to be created beforehand or it gets created as a file with the content of _static/plot_directive.css
	mkdir -p "${SAGE_DOC}"/html/en/reference/_static

	if use doc-html ; then
		HTML_DOCS="${SAGE_DOC}/html/*"
		emake doc-html PYTHON=${PYTHON}
	fi

	if use doc-pdf ; then
		DOCS="${SAGE_DOC}/pdf"
		emake doc-pdf PYTHON=${PYTHON}
	fi
}

src_install(){
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
		popd
	fi

	einstalldocs

	# Files needed for generating documentation on the fly
	docompress -x /usr/share/doc/"${PF}"/en /usr/share/doc/"${PF}"/common
	# necessary for sagedoc.py call to sphinxify.
	insinto /usr/share/doc/"${PF}"/common
	doins -r src/doc/common/themes

	if use doc-html; then
		dosym ../../../doc/"${PF}"/html/en /usr/share/jupyter/kernels/sagemath/doc
	fi
}
