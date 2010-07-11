# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://modular.math.washington.edu/home/wbhart/webpage/"
SRC_URI="http://modular.math.washington.edu/home/wbhart/webpage/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc qs mpir ntl"

RESTRICT="mirror"

CDEPEND="ntl? ( dev-libs/ntl )
	mpir? ( sci-libs/mpir )
	!mpir? ( dev-libs/gmp )"
DEPEND="${CDEPEND}
	>=sci-libs/zn_poly-0.9"
RDEPEND="${CDEPEND}"

src_prepare() {
	# use zn_poly from portage
	epatch "${FILESDIR}"/${PN}-1.5.1-without-zn_poly.patch

	# fixes to correctly use flags from portage
	epatch "${FILESDIR}"/${P}-makefile.patch

	# build ntl interface into libflint
	if use ntl ; then
		epatch "${FILESDIR}"/${P}-enable-ntl.patch
	fi

	if use mpir ; then
		epatch "${FILESDIR}"/${P}-use-mpir-instead-of-gmp.patch
	fi
}

src_compile() {
	export FLINT_GMP_INCLUDE_DIR=/usr/include
	export FLINT_GMP_LIB_DIR=$(get_libdir)
	export FLINT_LINK_OPTIONS="${LDFLAGS}"
	export FLINT_CC=$(tc-getCC)
	export FLINT_CPP=$(tc-getCXX)
	export FLINT_LIB=lib${PN}.so

	if use ntl ; then
		export FLINT_NTL_INCLUDE_DIR=/usr/include
		export FLINT_NTL_LIB_DIR=$(get_libdir)
	fi

	emake library || die

	if use qs ; then
		emake QS || die
	fi
}

src_test() {
	emake check || die

	if use ntl ; then
		emake NTL-interface-test || die

		# run test
		./NTL-interface-test || die "failed to run ntl interface test"
	fi
}

src_install(){
	# install library
	dolib.so libflint.so || die

	# install headers
	insinto /usr/include/FLINT
	doins *.h || die

	# install quadratic sieve program
	if use qs ; then
		dobin mpQS || die
	fi

	# install docs
	if use doc ; then
		doins doc/*.pdf || die
	fi
}
