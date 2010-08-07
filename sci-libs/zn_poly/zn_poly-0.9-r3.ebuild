# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic multilib

DESCRIPTION="A library for polynomial arithmetic"
HOMEPAGE="http://www.cims.nyu.edu/~harvey/code/zn_poly/"
SRC_URI="http://www.cims.nyu.edu/~harvey/code/zn_poly/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpir"

RESTRICT="mirror"

CDEPEND="mpir? ( sci-libs/mpir )
	!mpir? ( >=dev-libs/gmp-4.2.4 )"
DEPEND="${CDEPEND}
	dev-lang/python"
RDEPEND="${CDEPEND}"

src_prepare() {
	# both flint and zn_poly typedef "ulong" - fix it
	epatch "${FILESDIR}"/${P}-flint-hack.patch

	if use mpir ; then
		epatch "${FILESDIR}"/${P}-use-mpir-instead-of-gmp.patch
	fi

	# fix for multilib-strict
	sed -i "s:%s/lib:%s/$(get_libdir):g" makemakefile.py \
		|| die "failed to patch for multilib-strict"
}

# TODO: support flint instead of gmp option ?
src_configure() {
	append-cflags -fPIC

	# this command actually calls a python script
	./configure \
		--prefix="${ED}"/usr \
		--cflags="${CFLAGS}" \
		--ldflags="${LDFLAGS}" \
		--gmp-prefix=/usr \
		|| die "failed to configure sources"
}

src_compile() {
	# there is the possiblity to generate tuning values, but this actually slows
	# down the tests

	# make shared object only
	emake lib${P}.so || die
}

src_test() {
	emake test/test || die

	# run every test available - "make test" does not do this
	test/test all || die "tests failed"
}

src_install() {
	dolib.so lib${PN}.so lib${P}.so || die
	dodoc CHANGES || die
	insinto /usr/include/zn_poly
	doins include/wide_arith.h include/zn_poly.h || die
}
