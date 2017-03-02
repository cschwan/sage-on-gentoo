# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A C++ template library for linear algebra over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="sage static-libs openmp opencl"

# TODO: support examples ?

# disabling of commentator class breaks the tests
RESTRICT="mirror
	sage? ( test )"

DEPEND="dev-libs/gmp[cxx]
	~sci-libs/givaro-4.0.2
	~sci-libs/fflas-ffpack-2.2.2
	virtual/cblas
	virtual/lapack
	opencl? ( virtual/opencl )
	dev-libs/ntl:=
	sci-libs/iml
	dev-libs/mpfr:=
	sci-mathematics/flint"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog NEWS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-pkgconfig.patch
	)

# TODO: installation of documentation does not work ?

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
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
