# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic

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
}

src_configure() {
	append-cflags -fPIC

	# this command actually calls a python script
	./configure \
		--prefix="${D}"/usr \
		--cflags="${CFLAGS}" \
		--ldflags="${LDFLAGS}" \
		--gmp-prefix=/usr \
		|| die "configure failed"
}

src_compile() {
	# there is the possiblity to generate tuning values, but this actually slows
	# down the tests

	# TODO: build a shared object instead of archive or even both ?
# 	emake lib${P}.so || die "emake failed"
	emake || die "emake failed"
}

src_test() {
	# make test program
	emake test/test || die "emake failed"

	# run every test available - "make test" does not do this
	time test/test all || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc CHANGES || die "dodoc failed"
}
