# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A library for polynomial arithmetic"
HOMEPAGE="https://gitlab.com/sagemath/zn_poly"
SRC_URI="https://gitlab.com/sagemath/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND="dev-libs/gmp:="
BDEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# fix for multilib-strict
	sed -i "s:/lib:/$(get_libdir):g" makemakefile.py \
		|| die "failed to patch for multilib-strict"

	# fix install_name for macos
	sed -i "s:-dynamiclib:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libzn_poly.dylib:g" \
		makemakefile.py || die "failed to fix macos dylib"
}

# Note, in spite of being listed as required dev-libs/ntl is not used.
# TODO: support flint? This requires fixing all headers from FLINT to flint.
src_configure() {
	append-flags -fPIC

	# this command actually calls a python script
	./configure \
		--prefix="${ED}"/usr \
		--cflags="${CFLAGS}" \
		--ldflags="${LDFLAGS}" \
		--gmp-prefix="${EPREFIX}"/usr \
		|| die "failed to configure sources"
}

src_compile() {
	# there is the possiblity to generate tuning values, but this actually slows
	# down the tests

	# make shared object only
	if  [[ ${CHOST} == *-darwin* ]] ; then
		emake CC=$(tc-getCC) libzn_poly.dylib
	else
		emake CC=$(tc-getCC) libzn_poly.so
	fi
}

src_test() {
	emake test/test CC=$(tc-getCC)

	# run every test available - "make test" does not do this
	test/test all || die "tests failed"
}

src_install() {
	if  [[ ${CHOST} == *-darwin* ]] ; then
		dolib.so libzn_poly.dylib
	else
		dolib.so libzn_poly.so libzn_poly-$(ver_cut 1-2 ${PV}).so libzn_poly-${PV}.so
	fi

	dodoc CHANGES
	insinto /usr/include/zn_poly
	doins include/wide_arith.h include/zn_poly.h
}
