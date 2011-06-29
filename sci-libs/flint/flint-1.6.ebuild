# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc ntl test"

RESTRICT="mirror"

CDEPEND="ntl? ( dev-libs/ntl )
	dev-libs/mpfr
	>=sci-libs/zn_poly-0.9"
DEPEND="${CDEPEND}
	doc? ( virtual/latex-base )
	test? ( >=dev-libs/gmp-5 ) !test? ( dev-libs/gmp )"
RDEPEND="${CDEPEND}
	dev-libs/gmp"

src_prepare() {
	# make sure internal copy of zn_poly is not used
	rm -rf zn_poly

	# replace inclusion paths to system zn_poly
	sed -i "s:\"zn_poly/src/zn_poly\.h\":<zn_poly/zn_poly.h>:g" \
		fmpz_poly.c zmod_poly.h fmpz.h fmpz.c F_mpz.h F_mpz.c \
		|| die "failed to patch zn_poly header inclusions"

	# fix CFLAGS, CXXFLAGS, LDFLAGS use, remove usage of internal zn_poly and
	# compile ntl stuff with CXXFLAGS instead of CFLAGS
	epatch "${FILESDIR}"/${PN}-1.6-makefile.patch

	# build ntl interface into libflint
	if use ntl ; then
		epatch "${FILESDIR}"/${PN}-1.6-enable-ntl.patch
	fi

	# fix install name for macos
	sed -i "s:-dynamiclib:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libflint.dylib:g" \
		makefile || die "failed to fix macos support"
}

src_compile() {
	tc-export CC CXX

	emake FLINT_LIB=lib${PN}$(get_libname) library

	if use doc ; then
		cd doc
		pdflatex ${P}.tex || die "pdflatex run 1 failed"
		pdflatex ${P}.tex || die "pdflatex run 2 failed"
		cd ..
	fi
}

src_test() {
	# TODO: shows some failures, examine if we have to fix them
	emake check

	if use ntl ; then
		emake NTL-interface-test

		./NTL-interface-test || die "failed to run ntl interface test"
	fi
}

src_install() {
	dolib.so libflint$(get_libname)

	insinto /usr/include/FLINT
	doins *.h

	if use doc ; then
		dodoc doc/${P}.pdf
	fi
}
