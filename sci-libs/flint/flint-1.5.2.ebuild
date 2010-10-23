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
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc qs mpir ntl"

RESTRICT="mirror"

DEPEND="ntl? ( dev-libs/ntl )
	mpir? ( sci-libs/mpir )
	!mpir? ( dev-libs/gmp )
	>=sci-libs/zn_poly-0.9"
RDEPEND="${DEPEND}"

src_prepare() {
	# do not use internal copy of zn_poly
	epatch "${FILESDIR}"/${PN}-1.5.1-without-zn_poly.patch

	# use CXXFLAGS for C++ files and add -fPIC if needed
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
	local flint_flags=(
		FLINT_CC=$(tc-getCC)
		FLINT_CPP=$(tc-getCXX)
		FLINT_LIB=lib${PN}.so
		FLINT_LINK_OPTIONS="${LDFLAGS}"
	)

	emake "${flint_flags[@]}" library || die

	if use qs ; then
		emake "${flint_flags[@]}" QS || die
	fi
}

src_test() {
	emake check || die

	if use ntl ; then
		emake NTL-interface-test || die

		./NTL-interface-test || die "failed to run ntl interface test"
	fi
}

src_install(){
	dolib.so libflint.so || die

	insinto /usr/include/FLINT
	doins *.h || die

	if use qs ; then
		dobin mpQS || die
	fi

	if use doc ; then
		doins doc/*.pdf || die
	fi
}
