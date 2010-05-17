# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scipy/scipy-0.7.1.ebuild,v 1.10 2010/02/28 10:53:17 arfrever Exp $

EAPI="2"
NEED_PYTHON="2.4"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils flag-o-matic toolchain-funcs versionator

SP="${PN}-$(get_version_component_range 1-2)"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? (
		http://docs.scipy.org/doc/${SP}.x/${PN}-html.zip -> ${SP}-html.zip
		http://docs.scipy.org/doc/${SP}.x/${PN}-ref.pdf -> ${SP}-ref.pdf
	)"
DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="http://www.scipy.org/"

LICENSE="BSD"

SLOT="0"
IUSE="doc umfpack"

KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

CDEPEND=">=dev-python/numpy-1.2
	virtual/cblas
	virtual/lapack
	umfpack? ( sci-libs/umfpack )"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	umfpack? ( dev-lang/swig )
	doc? ( app-arch/unzip )"
#	test? ( dev-python/nose )

RDEPEND="${CDEPEND}
	dev-python/imaging"

RESTRICT_PYTHON_ABIS="3.*"

# buggy tests
RESTRICT="test"

DOCS="THANKS.txt LATEST.txt TOCHANGE.txt"

pkg_setup() {
	# scipy automatically detects libraries by default
	export {FFTW,FFTW3,UMFPACK}=None
	use umfpack && unset UMFPACK
	# the missing symbols are in -lpythonX.Y, but since the version can
	# differ, we just introduce the same scaryness as on Linux/ELF
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared
	[[ -z ${FC}  ]] && export FC=$(tc-getFC)
	# hack to force F77 to be FC until bug #278772 is fixed
	[[ -z ${F77} ]] && export F77=$(tc-getFC)
	export SCIPY_FCONFIG="config_fc --noopt --noarch"
}

src_unpack() {
	unpack ${P}.tar.gz
	if use doc; then
		unzip -qo "${DISTDIR}"/${SP}-html.zip -d html || die
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.0_beta1-implicit.patch
	epatch "${FILESDIR}"/${PN}-0.6.0-stsci.patch
	epatch "${FILESDIR}"/${PN}-0.7.1-weave.patch
	# apply changeset 5790 from scipy trunk
	epatch "${FILESDIR}"/${PN}-0.7-optimize.patch
	cat > site.cfg <<-EOF
		[DEFAULT]
		library_dirs = /usr/$(get_libdir)
		include_dirs = /usr/include
		[atlas]
		include_dirs = $(pkg-config --cflags-only-I \
			cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
		library_dirs = $(pkg-config --libs-only-L \
			cblas blas lapack| sed -e \
			's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):/usr/$(get_libdir)
		atlas_libs = $(pkg-config --libs-only-l \
			cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		lapack_libs = $(pkg-config --libs-only-l \
			lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		[blas_opt]
		include_dirs = $(pkg-config --cflags-only-I \
			cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
		library_dirs = $(pkg-config --libs-only-L \
			cblas blas | sed -e 's/^-L//' -e 's/ -L/:/g' \
			-e 's/ //g'):/usr/$(get_libdir)
		libraries = $(pkg-config --libs-only-l \
			cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		[lapack_opt]
		library_dirs = $(pkg-config --libs-only-L \
			lapack | sed -e 's/^-L//' -e 's/ -L/:/g' \
			-e 's/ //g'):/usr/$(get_libdir)
		libraries = $(pkg-config --libs-only-l \
			lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
	EOF
}

src_compile() {
	[[ -n ${FFLAGS} ]] && FFLAGS="${FFLAGS} -fPIC"
	distutils_src_compile ${SCIPY_FCONFIG}
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install \
			--home="${S}/test-${PYTHON_ABI}" --no-compile ${SCIPY_FCONFIG} || die "install test failed"
		pushd "${S}/test-${PYTHON_ABI}/"lib*/python > /dev/null
		PYTHONPATH=. "$(PYTHON)" -c "import scipy; scipy.test('full')" 2>&1 | tee test.log
		grep -q ^ERROR test.log && die "test failed"
		popd > /dev/null
		rm -fr test-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install ${SCIPY_FCONFIG}
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r "${WORKDIR}"/html || die
		doins  "${DISTDIR}"/${SP}*pdf || die
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "You might want to set the variable SCIPY_PIL_IMAGE_VIEWER"
	elog "to your prefered image viewer if you don't like the default one. Ex:"
	elog "\t echo \"export SCIPY_PIL_IMAGE_VIEWER=display\" >> ~/.bashrc"
}
