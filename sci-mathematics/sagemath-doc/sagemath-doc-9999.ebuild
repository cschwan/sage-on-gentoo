# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="readline,sqlite"

inherit multiprocessing python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sagemath/sage.git"
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
	~sci-mathematics/sagemath-${PV}[\${PYTHON_USEDEP},jmol]
	")
	doc-pdf? (
		>=app-text/texlive-2023[extra,luatex,${L10N_USEDEP}]
		>=app-text/texlive-core-2023[xindy]
		media-fonts/freefont
	)
"
RDEPEND="dev-libs/mathjax"
DEPEND="dev-libs/mathjax"

HTML_DOCS="${WORKDIR}/build_doc/src/doc/html/*"
DOCS=(
	"${WORKDIR}/build_doc/src/doc/index.html"
	"${S}/src/doc/common"
)

PATCHES=(
	"${FILESDIR}/40904.patch"
	"${FILESDIR}/${PN}-10.8-warnings.patch"
	"${FILESDIR}/${PN}-10.7-linguas.patch"
)

# python_check_deps happilly processes $PV.
python_check_deps() {
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version -b "~sci-mathematics/sagemath-${PV}[${PYTHON_USEDEP},jmol]" &&
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

	# sage on gentoo environment variables - steal from already installed file.
	sage_init_path=$(sage -c "print(f'{sage.__file__}')")
	sage_config_path="${sage_init_path%__init__.py}config.py"
	sage_conf_file="pkgs/sage-conf/_sage_conf/_conf.py.in"
	cp -f "${sage_config_path}" "${sage_conf_file}"
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

	meson setup "${WORKDIR}/build_doc"
}

src_compile(){
	# for some reason luatex check whether it can write there.
	# Of course it should fail, but it triggers the sandbox.
	addpredict /var/lib/texmf/m_t_x_t_e_s_t.tmp
	# for some reason opened for write during inventory of reference/plotting(?) - no write happens.
	# This manifest as root
	addpredict "${ESYSROOT}/usr/share/sage/cremona/cremona_mini.db"
	# For some reason java/jmol ignores HOME and uses portage's home as home directory
	# Nothing seem to happen though
	addpredict "${ESYSROOT}/var/lib/portage/home/.java"

	meson compile -C "${WORKDIR}/build_doc" doc-html
}

src_install(){
	####################################
	# Prepare the documentation for installation
	####################################

	pushd "${WORKDIR}/src/doc"
	# Prune _static folders
	cp -r html/en/_static html/ || die "failed to copy _static folder"
	for sdir in `find html -name _static` ; do
		if [ $sdir != "html/_static" ] ; then
			rm -rf $sdir || die "failed to remove $sdir"
			ln -rst ${sdir%_static} html/_static
		fi
	done
	# Linking to local copy of mathjax folders rather than copying them
	for sobject in $(ls "${ESYSROOT}"/usr/share/mathjax/) ; do
		rm -rf html/_static/${sobject} \
			|| die "failed to remove mathjax object $sobject"
		ln -st html/_static/ ../../../../mathjax/$sobject
	done
	# prune .buildinfo files, those are internal to sphinx and are not used after building.
	find . -name .buildinfo -delete || die "failed to prune buildinfo files"
	# prune the jupyter_execute folder created by jupyter-sphinx
	rm -rf html/en/reference/jupyter_execute
	popd

	docompress -x /usr/share/doc/"${PF}"/common
	einstalldocs

	dosym -r /usr/share/doc/"${PF}" /usr/share/jupyter/kernels/sagemath/doc
}
