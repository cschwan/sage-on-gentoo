# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils

DESCRIPTION="A multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="http://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI="http://gforge.inria.fr/frs/download.php/22256/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.1.2
	>=dev-libs/mpfr-2.0.1"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS ChangeLog NEWS )
PATCHES=( "${FILESDIR}"/${P}-mpfr3.patch )

src_prepare() {
	if use test ; then
		# link against shared object - archive will be removed
		sed -i "s:libmpfi.a:libmpfi.so:g" tests/Makefile.am \
			|| die "failed to patch tests/Makefile.am"
	else
		# do not build tests if we dont need them
		sed -i "s: tests/Makefile::g" configure.ac \
			|| die "failed to patch configure.ac"
		sed -i "s: tests::g" configure.ac || die "failed to patch configure.ac"
	fi

	eautoreconf
	autotools-utils_src_prepare
}

src_test() {
	autotools-utils_src_test

	# TODO: tests are looking a bit useless
	tests/test_mpfi || die "test_mpfi failed"
	tests/test_trigo || die "test_trigo failed"
}