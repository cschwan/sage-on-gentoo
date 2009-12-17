# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qs openmp ntl doc"

DEPEND="ntl? ( dev-libs/ntl )
	openmp? ( sys-devel/gcc[openmp] )
	dev-libs/gmp
	>=sci-libs/zn_poly-0.9"
RDEPEND="ntl? ( dev-libs/ntl )
	dev-libs/gmp"

RESTRICT="mirror"

src_prepare() {
	# use zn_poly from portage
	epatch "${FILESDIR}/${P}-without-zn_poly.patch"

	if use ntl ; then
		# build ntl interface into libflint (same way as Sage does)
		epatch "${FILESDIR}/${P}-enable-ntl.patch"
	fi

	# fix QA warning
	sed -i "s:-shared -o libflint.so:-shared -Wl,-soname,libflint.so -o libflint.so:" \
		makefile

	# remove CFLAGS - use from portage
	sed -i "s:CFLAGS = \$(INCS) \$(FLINT_TUNE) -O2::" makefile

	# TODO: this needs testing, does not work (?)

	# add support for openmp
	if use openmp ; then
		sed -i "s:CFLAGS2 = \$(INCS) \$(FLINT_TUNE) -O2:CFLAGS2 = \$(CFLAGS) -openmp :" \
			makefile
	else
		sed -i "s:CFLAGS2 = \$(INCS) \$(FLINT_TUNE) -O2:CFLAGS2 = \$(CFLAGS) :" \
			makefile
	fi

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

	emake library || die "Building flint shared library failed!"

	if use qs ; then
		emake QS || die "Building flintQS failed!"
	fi

	# TODO: examples ?
}

src_install(){
	dolib.so libflint.so || die "installation of library failed!"

	insinto /usr/include/FLINT
	doins *.h || die "installation of headers failed!"

	if use qs ; then
		dobin mpQS || die "installation of mpQS failed!"
	fi

	if use doc ; then
		insinto /usr/share/doc/"${PF}"
		doins doc/*.pdf || die "Failed to install docs"
	fi
}
