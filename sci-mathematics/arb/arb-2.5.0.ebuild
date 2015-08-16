# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base multilib toolchain-funcs

DESCRIPTION="Arb is a C library for arbitrary-precision floating-point ball arithmetic."
HOMEPAGE="http://fredrikj.net/arb/"
SRC_URI="https://github.com/fredrik-johansson/arb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64  ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RDEPEND=">=sci-mathematics/flint-2.4.4"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.5.0-makefile.in.patch
	"${FILESDIR}"/${PN}-2.5.0-dedekind_sum-check.patch )

src_configure() {
	# Not an autoconf configure script.
	# Note that it appears to have been cloned from the flint configure script
	# and that not all the options offered are valid.
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-flint="${EPREFIX}/usr" \
		--with-gmp="${EPREFIX}/usr" \
		--with-mpfr="${EPREFIX}/usr" \
		$(use_enable static-libs static) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		|| die
}

src_compile() {
	emake verbose
}

src_test() {
	emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
}
