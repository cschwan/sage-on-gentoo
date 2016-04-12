# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Arb is a C library for arbitrary-precision floating-point ball arithmetic."
HOMEPAGE="http://fredrikj.net/arb/"
SRC_URI="https://github.com/fredrik-johansson/arb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64  ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RDEPEND=">=sci-mathematics/flint-2.5.0:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-makefile.in.patch
	"${FILESDIR}"/${PN}-2.7.0-flint_includes.patch
	)

src_configure() {
	# Figure extra flags for linking
	local extra_ldflags=""
	if ! [[ ${CHOST} == *-darwin* ]] ; then
		extra_ldflags="-Wl,-soname=libarb.so"
	fi
	# Not an autoconf configure script.
	# Note that it appears to have been cloned from the flint configure script
	# and that not all the options offered are valid.
	EXTRA_SHARED_FLAGS="${extra_ldflags}" ./configure \
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
	# Have to set the library path otherwise a previous install of libarb may be loaded.
	# This is in part a consequence of setting the soname/installnae I think.
	if [[ ${CHOST} == *-darwin* ]] ; then
		DYLD_LIBRARY_PATH="${S}" emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
	else
		LD_LIBRARY_PATH="${S}" emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
	fi
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
}
