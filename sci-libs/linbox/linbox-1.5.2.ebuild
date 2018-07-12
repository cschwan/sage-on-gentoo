# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A C++ template library for linear algebra over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="sage static-libs openmp opencl"

RESTRICT="mirror"

DEPEND="dev-libs/gmp[cxx]
	~sci-libs/givaro-4.0.4
	=sci-libs/fflas-ffpack-2.3*
	virtual/cblas
	virtual/lapack
	opencl? ( virtual/opencl )
	dev-libs/ntl:=
	sci-libs/iml
	dev-libs/mpfr:=
	sci-mathematics/flint"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.2-fix-gcc-8.1-compat.patch
	)

# TODO: installation of documentation does not work ?

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare(){
	default

	if use sage ; then
		# patch provided by upstream to deal with some behavior in sage
		# Some future version of linbox will enable choosing between
		# implementations at runtime.
		eapply "${FILESDIR}"/${PN}-1.5.2-charpoly_fullCRA.patch
	fi
}

src_configure() {
	econf \
		--with-all="${EPREFIX}"/usr \
		--without-fplll \
		$(use_enable sage) \
		$(use_enable openmp) \
		$(use_with opencl ocl) \
		$(use_enable static-libs static)
}

src_install(){
	default
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
