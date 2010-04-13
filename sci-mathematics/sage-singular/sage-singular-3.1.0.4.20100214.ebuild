# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic autotools multilib versionator sage

MY_P="singular-$(replace_all_version_separators '-')"

DESCRIPTION="Sage's version of singular: Computer algebra system for polynomial computations"
# The ebuild is crude - so is singular for that matter.
# TODO Splitting the ebuild to build libsingular separately to enforce correct pic-ness.
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"
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

append-flags -fPIC

src_prepare () {
	cp ../patches/mminit.cc kernel/
	cp ../patches/assert.h factory/
	cp ../patches/kernel.rmodulon.cc kernel/rmodulon.cc
	cp ../patches/src.Singular.Makefile.in Singular/Makefile.in
	cp ../patches/Singular.libsingular.h Singular/libsingular.h
	cp ../patches/factory.GNUmakefile.in factory/GNUmakefile.in
	cp ../patches/libfac.charset.alg_factor.cc libfac/charset/alg_factor.cc
	cp ../patches/kernel.Makefile.in kernel/Makefile.in
	cp ../patches/Singular.Makefile.in Singular/Makefile.in
	cp ../patches/Singular.tesths.cc Singular/tesths.cc

	mkdir -p build
}

src_configure() {
	local myconf="--prefix=${S}/build${SAGE_LOCAL} \
			--exec-prefix=${S}/build${SAGE_LOCAL} \
			--bindir=${S}/build${SAGE_LOCAL}/bin \
			--libdir=${S}/build${SAGE_LOCAL}/$(get_libdir) \
			--libexecdir=${S}/build${SAGE_LOCAL}/$(get_libdir) \
			--with-apint=gmp \
			--with-gmp=/usr \
			--with-NTL \
			--with-ntl=/usr \
			--without-MP \
			--without-lex \
			--without-bison \
			--without-Boost \
			--enable-Singular \
			--enable-IntegerProgramming \
			--enable-factory \
			--enable-libfac \
			--disable-doc \
			--with-malloc=system"

	econf ${myconf} || die "econf failed"
}

src_compile() {
	emake -j1 || die "make failed"
	emake slibdir="${S}/build${SAGE_LOCAL}/share/singular" install-nolns || die "install-nolns failed"
	emake -j1 libsingular || "emake libsingular failed"
	emake -j1 install-libsingular || die "emake install-libsingular failed"
#	The following is needed to get libfac.a libcf.a? libcfmem.a?
#	libsingcf_g.a? libsingfac.a? (the last 2 have some defects)
#	We should check that all these are really needed.
#	Then if needed check if we could build a specific target rather than reconfiguring.
#	Not that we cannot move these configurations in src_configure as it breaks.
	cd ${S}/factory
	emake distclean
	./configure --prefix="${S}/build${SAGE_LOCAL}" \
		--exec-prefix="${S}/build${SAGE_LOCAL}" \
		--bindir="${S}/build${SAGE_LOCAL}/bin" \
		--libdir="${S}/build${SAGE_LOCAL}/$(get_libdir)" \
		--libexecdir="${S}/build${SAGE_LOCAL}/$(get_libdir)" \
		--with-apint=gmp \
		--with-gmp=/usr \
		--with-NTL \
		--with-ntl=/usr
	emake -j1
	emake -j1 install || die "factory install failed"
	cd ${S}/libfac
	emake distclean
	./configure --prefix="${S}/build${SAGE_LOCAL}" \
		--exec-prefix="${S}/build${SAGE_LOCAL}" \
		--bindir="${S}/build${SAGE_LOCAL}/bin" \
		--libdir="${S}/build${SAGE_LOCAL}/$(get_libdir)" \
		--libexecdir="${S}/build${SAGE_LOCAL}/$(get_libdir)" \
		--with-apint=gmp \
		--with-gmp=/usr \
		--with-NTL \
		--with-ntl=/usr
		--enable-factory \
		--enable-libfac \
                --enable-omalloc
	emake -j1
	emake -j1 install || die "libfac install failed"
}

src_install(){
#	Not making the link LIB to lib since it seems to be incorrect in the first place.
	cp -R build/* "${D}"
	rm "${D}${SAGE_LOCAL}/bin/Singular"
	rm "${D}${SAGE_LOCAL}/LIB"
	cp "${FILESDIR}/singular" "${D}${SAGE_LOCAL}/bin"
	cp "${D}${SAGE_LOCAL}/bin/singular" "${D}${SAGE_LOCAL}/bin/Singular"
	cd "${D}${SAGE_LOCAL}/bin/"
	ln -sf Singular sage_singular
	cp "${S}/../shared/singular.hlp" "${D}${SAGE_LOCAL}/share/singular"
	cp "${S}/../shared/singular.idx" "${D}${SAGE_LOCAL}/share/singular"
#	Beware that when we move stuff in /usr we should make sure
#	that we call singular's binaries in $SAGE_LOCAL.
}
