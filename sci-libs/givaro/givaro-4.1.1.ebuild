# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="https://github.com/linbox-team/givaro/releases/download/v${PV}/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0/9"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2 bindist"

REQUIRED_USE="bindist? ( !cpu_flags_x86_fma3 !cpu_flags_x86_fma4 !cpu_flags_x86_sse3 !cpu_flags_x86_ssse3 !cpu_flags_x86_sse4_1 !cpu_flags_x86_sse4_2 !cpu_flags_x86_avx !cpu_flags_x86_avx2 )"

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-4.0[cxx]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog )

src_configure(){
	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_fma3 fma) \
		$(use_enable cpu_flags_x86_fma4 fma4) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41) \
		$(use_enable cpu_flags_x86_sse4_2 sse42) \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2)
}

src_install(){
	default
	# Remove la file
	find "${ED}" -name '*.la' -delete || die
}
