# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A C++ template library for linear algebra over integers and over finite fields"
HOMEPAGE="https://linalg.org/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs openmp opencl cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"

RESTRICT=primaryuri

DEPEND="dev-libs/gmp[cxx]
	=sci-libs/givaro-4.1*
	=sci-libs/fflas-ffpack-2.4*
	virtual/cblas
	virtual/lapack
	opencl? ( virtual/opencl )
	dev-libs/ntl:=
	sci-libs/iml
	dev-libs/mpfr:=
	sci-mathematics/flint"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.3-pc.patch
)

DOCS=( ChangeLog )

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
		$(use_enable openmp) \
		$(use_with opencl ocl) \
		$(use_enable cpu_flags_x86_fma3 fma) \
		$(use_enable cpu_flags_x86_fma4 fma4) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41) \
		$(use_enable cpu_flags_x86_sse4_2 sse42) \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2) \
		$(use_enable static-libs static)
}

src_install(){
	default
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
