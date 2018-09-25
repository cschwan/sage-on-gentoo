# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="FFLAS-FFPACK is a library for dense linear algebra over word-size finite fields."
HOMEPAGE="https://linbox-team.github.io/fflas-ffpack/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs openmp cpu_flags_x86_sse4_1 cpu_flags_x86_avx cpu_flags_x86_avx2 bindist"

REQUIRED_USE="bindist? ( !cpu_flags_x86_sse4_1 !cpu_flags_x86_avx !cpu_flags_x86_avx2 )"

RESTRICT="mirror"

DEPEND="virtual/cblas
	virtual/lapack
	>=dev-libs/gmp-4.0[cxx]
	~sci-libs/givaro-4.0.2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.2-blaslapack.patch"
	)

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

pkg_setup(){
	tc-export PKG_CONFIG
	if( (use cpu_flags_x86_avx) || (use cpu_flags_x86_avx2) || (use cpu_flags_x86_sse4_1) ); then
		einfo "You have enabled one of avx/avx2/sse4.1 useflag."
		einfo "There is no granularity inside the package, enabling one will enable"
		einfo "all the ones that are available on your platform."
		einfo "You unfortunately cannot selectively turn one off."
	fi
	if use openmp; then
		einfo "using openmp within fflas-ffpack can cause compilation failures"
		einfo "with particular compilers and possibly blas/cblas implementation"
		einfo "If the build fails, try without openmp before reporting a new issue"
	fi
}

src_prepare(){
	default

	eautoreconf
}

src_configure() {
	local simd_opt="--disable-avx"
	if( (use cpu_flags_x86_avx) || (use cpu_flags_x86_avx2) || (use cpu_flags_x86_sse4_1) ); then
		simd_opt="--enable-simd"
	fi

	econf \
		--enable-optimization \
		--enable-precompilation \
		$(use_enable openmp) \
		${simd_opt} \
		$(use_enable static-libs static)
}

src_install(){
	default
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
