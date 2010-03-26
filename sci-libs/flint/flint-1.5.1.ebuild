# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://modular.math.washington.edu/home/wbhart/webpage/"
SRC_URI="http://modular.math.washington.edu/home/wbhart/webpage/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="qs ntl doc"

CDEPEND="ntl? ( dev-libs/ntl )
	dev-libs/gmp"
DEPEND="${CDEPEND}
	>=sci-libs/zn_poly-0.9"
RDEPEND="${CDEPEND}"

RESTRICT="mirror"

# TODO: examples, openmp ?

src_prepare() {
	# use zn_poly from portage
	epatch "${FILESDIR}/${P}-without-zn_poly.patch"

	# build ntl interface into libflint
	if use ntl ; then
		epatch "${FILESDIR}/${P}-enable-ntl.patch"
	fi

	# fix QA warning
	sed -i "s:-shared -o libflint.so:-shared -Wl,-soname,libflint.so -o libflint.so:" \
		makefile

	# remove CFLAGS - use from portage
	sed -i "s:CFLAGS = \$(INCS) \$(FLINT_TUNE) -O2::" makefile

	# use CXXFLAGS for C++ code
	sed -i "s:\$(CPP) \$(CFLAGS):\$(CPP) \$(CXXFLAGS):" makefile
}

src_compile() {
	export FLINT_GMP_INCLUDE_DIR=/usr/include
	export FLINT_GMP_LIB_DIR=$(get_libdir)
	export FLINT_NTL_LIB_DIR=$(get_libdir)
	export FLINT_LINK_OPTIONS="${LDFLAGS}"
	export FLINT_CC=$(tc-getCC)
	export FLINT_CPP=$(tc-getCXX)
	export FLINT_LIB="libflint.so"

	emake library || die "emake failed"

	if use qs ; then
		emake QS || die "emake failed"
	fi
}

src_install(){
	# install library
	dolib.so libflint.so || die "dolib failed"

	# install headers
	insinto /usr/include/FLINT
	doins *.h || die "doins failed"

	# install quadratic sieve program
	if use qs ; then
		dobin mpQS || die "dobin failed"
	fi

	# install docs
	if use doc ; then
		doins doc/*.pdf || die "doins failed"
	fi
}
