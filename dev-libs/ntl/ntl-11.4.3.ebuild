# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic toolchain-funcs

DESCRIPTION="High-performance and portable Number Theory C++ library"
HOMEPAGE="https://shoup.net/ntl/"
SRC_URI="https://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/43"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="bindist doc static-libs test threads cpu_flags_x86_avx2"

RDEPEND="dev-libs/gmp:0=
	>=dev-libs/gf2x-0.9
	threads? ( >=dev-libs/gf2x-1.2 )"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}/src"

REQUIRED_USE="bindist? ( !cpu_flags_x86_avx2 )"

DOCS=( "${WORKDIR}/${P}"/README )

pkg_setup() {
	replace-flags -O[3-9] -O2
}

src_configure() {
	# Currently the build system can build a static library or
	# both static and shared libraries. But not only shared libraries.
	perl DoConfig \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		CXXFLAGS="${CXXFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		SHARED=on \
		NTL_GMP_LIP=on NTL_GF2X_LIB=on \
		$(usex threads NTL_THREADS= NTL_THREADS= on off) \
		$(usex cpu_flags_x86_avx2 NTL_ENABLE_AVX_FFT= NTL_ENABLE_AVX_FFT= on off) \
		$(usex bindist NATIVE= NATIVE= off on) \
		|| die "DoConfig failed"

	if use doc; then
		DOCS+=( "${WORKDIR}/${P}"/doc/*.txt )
		HTML_DOCS=( "${WORKDIR}/${P}"/doc/*.html "${WORKDIR}/${P}"/doc/*.gif )
	fi
}

src_install() {
	default
	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/libntl.{la,a}
	fi

	cd ..
	rm -rf "${ED}"/usr/share/doc/NTL
}
