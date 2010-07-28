# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic multilib versionator sage

MY_P="singular-3-1-1-4"

DESCRIPTION="Sage's version of singular: Computer algebra system for polynomial computations"
# TODO Splitting the ebuild to build libsingular separately to enforce correct pic-ness.
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_URI="http://sage.math.washington.edu/home/malb/spkgs/singular-3-1-1-4.spkg -> ${P}.tar.bz2"
#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

RDEPEND=">=dev-libs/gmp-4.1-r1
	>=dev-libs/ntl-5.5.1"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5.6"

S="${WORKDIR}/${MY_P}/src"

src_prepare () {
	sed -i "s:@INSTALL_PROGRAM@  -s:@INSTALL_PROGRAM@:g" \
		IntegerProgramming/Makefile.in || die "failed to patch make file"

	mkdir -p build || die "failed to create build directory"
}

src_configure() {
	append-flags -fPIC

	econf --prefix="${S}"/build \
		--exec-prefix="${S}"/build \
		--bindir="${S}"/build/bin \
		--libdir="${S}"/build/lib \
		--libexecdir="${S}"/build/lib \
		--with-apint=gmp \
		--with-gmp=/usr \
		--with-NTL \
		--with-ntl=/usr \
		--without-MP \
		--without-lex \
		--without-bison \
		--without-Boost \
		--enable-gmp=/usr \
		--enable-Singular \
		--enable-IntegerProgramming \
		--enable-factory \
		--enable-libfac \
		--disable-doc \
		--with-malloc=system || die
}

src_compile() {
	emake -j1 || die
	emake slibdir="${S}/build/share/singular" install-nolns || die
	emake -j1 libsingular || die
	emake -j1 install-libsingular || die
}

src_install(){
#	Not making the link LIB to lib since it seems to be incorrect in the first place.
	rm build/bin/Singular || die "failed to remove useless files"
	rm build/LIB || die "failed to remove useless files"

	into "${SAGE_LOCAL}"
	dobin build/bin/* || die
	newbin "${FILESDIR}"/singular-3.1.1 singular || die
	newbin "${FILESDIR}"/singular-3.1.1 Singular || die
	dosym Singular "${SAGE_LOCAL}"/bin/sage_singular || die

	dolib build/lib/*.so build/lib/*.a build/lib/*.o || die

	insinto "${SAGE_LOCAL}"/share
	doins -r build/share/* || die
	insinto "${SAGE_LOCAL}"/share/singular
	doins "${S}"/../shared/singular.hlp "${S}"/../shared/singular.idx || die

	insinto "${SAGE_LOCAL}"/include
	doins -r build/include/* || die
#	Beware that when we move stuff in /usr we should make sure
#	that we call singular's binaries in $SAGE_LOCAL.
}
