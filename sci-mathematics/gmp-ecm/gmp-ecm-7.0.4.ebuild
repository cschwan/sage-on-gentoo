# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/36224/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+custom-tune gwnum -openmp static-libs cpu_flags_x86_sse2"

DEPEND="
	dev-libs/gmp:=
	!sci-mathematics/ecm
	gwnum? ( sci-mathematics/gwnum )"
RDEPEND="${DEPEND}"

# can't be both enabled
REQUIRED_USE="gwnum? ( !openmp )
	x86-macos? ( !custom-tune )"

S="${WORKDIR}"/ecm-${PV}

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	use gwnum && local myconf="--with-gwnum="${EPREFIX}"/usr/$(get_libdir)"
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable custom-tune asm-redc) \
		${myconf}
}
