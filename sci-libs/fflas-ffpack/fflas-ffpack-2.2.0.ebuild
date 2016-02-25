# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools toolchain-funcs

MY_PN="fflas_ffpack"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="FFLAS-FFPACK is a library for dense linear algebra over word-size finite fields."
HOMEPAGE="http://linalg.org/projects/fflas-ffpack"
SRC_URI="http://lig-membres.imag.fr/pernet/prereleases/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs openmp cpu_flags_x86_sse4_1 cpu_flags_x86_avx cpu_flags_x86_avx2 bindist"

REQUIRED_USE="bindist? ( !cpu_flags_x86_sse4_1 !cpu_flags_x86_avx !cpu_flags_x86_avx2 )"

RESTRICT="mirror"

DEPEND="virtual/cblas
	virtual/lapack
	>=dev-libs/gmp-4.0[cxx]
	~sci-libs/givaro-4.0.1"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-blaslapack.patch"
	)

S="${WORKDIR}"/${MY_P}

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

pkg_setup(){
	tc-export PKG_CONFIG
}

src_prepare(){
	default

	eautoreconf
}

src_configure() {
	local avx_opt="--disable-avx"
	if( (use cpu_flags_x86_avx) || (use cpu_flags_x86_avx2) ); then
		avx_opt="--enable-avx"
	fi

	econf \
		--enable-optimization \
		--enable-precompilation \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse4_1 sse) \
		${avx_opt} \
		$(use_enable static-libs static)
}
