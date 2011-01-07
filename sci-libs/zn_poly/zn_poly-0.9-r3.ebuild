# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic multilib

DESCRIPTION="A library for polynomial arithmetic"
HOMEPAGE="http://www.cims.nyu.edu/~harvey/code/zn_poly/"
SRC_URI="http://www.cims.nyu.edu/~harvey/code/zn_poly/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="mpir"

RESTRICT="mirror"

CDEPEND=">=dev-libs/gmp-4.2.4"
DEPEND="${CDEPEND}
	dev-lang/python"
RDEPEND="${CDEPEND}"

src_prepare() {
	# both flint and zn_poly typedef "ulong" - fix it
	epatch "${FILESDIR}"/${P}-flint-hack.patch

	# fix for multilib-strict
	sed -i "s:%s/lib:%s/$(get_libdir):g" makemakefile.py \
		|| die "failed to patch for multilib-strict"

	# fix to make zn_poly respect LDFLAGS in all targets
	sed -i "s:\$(LIBOBJS) \$(LIBS):\$(LDFLAGS) \$(LIBOBJS) \$(LIBS):g" \
		makemakefile.py || die "failed to add linker flags"

	# fix install_name for macos
	sed -i "s:-dynamiclib:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libzn_poly.dylib:g" \
		makemakefile.py || die "failed to fix macos dylib"
}

# TODO: support flint instead of gmp option ?
src_configure() {
	append-cflags -fPIC

	# this command actually calls a python script
	./configure \
		--prefix="${ED}"/usr \
		--cflags="${CFLAGS}" \
		--ldflags="${LDFLAGS}" \
		--gmp-prefix="${ED}"/usr \
		|| die "failed to configure sources"
}

src_compile() {
	# there is the possiblity to generate tuning values, but this actually slows
	# down the tests

	# make shared object only
	if  [[ ${CHOST} == *-darwin* ]] ; then
		emake libzn_poly.dylib || die
	else
		emake lib${P}.so || die
	fi
}

src_test() {
	emake test/test || die

	# run every test available - "make test" does not do this
	test/test all || die "tests failed"
}

src_install() {
	if  [[ ${CHOST} == *-darwin* ]] ; then
		dolib.so libzn_poly.dylib || die
	else
		dolib.so lib${PN}.so lib${P}.so || die
	fi
	dodoc CHANGES || die
	insinto /usr/include/zn_poly
	doins include/wide_arith.h include/zn_poly.h || die
}
