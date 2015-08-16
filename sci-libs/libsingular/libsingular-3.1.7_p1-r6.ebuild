# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic multilib prefix versionator

MY_PN=Singular
PV1=$(replace_all_version_separators -)
MY_PV=$(delete_version_separator 3 ${PV1})
MY_DIR=$(get_version_component_range 1-3 ${PV1})
# Note: Upstream's share tarball may not get updated on every release
MY_PV_SHARE="${MY_DIR}"
PN_PATCH=singular

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_COM="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${MY_PN}"
SRC_URI="${SRC_COM}-${MY_PV}.tar.gz"

RESTRICT="mirror test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="boost flint debug"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/ntl:0=
	flint? ( >=sci-mathematics/flint-2.3:= )"

DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost:0= )"

S="${WORKDIR}"/${MY_PN}-${MY_DIR}

pkg_setup() {
	append-cppflags -DLIBSINGULAR
	append-flags -fPIC
	append-ldflags -fPIC
	tc-export CC CPP CXX
}

src_prepare () {
	epatch \
		"${FILESDIR}"/${PN_PATCH}-3.1.0-gentoo.patch \
		"${FILESDIR}"/${PN_PATCH}-3.1.3.3-Minor.h.patch \
		"${FILESDIR}"/${PN_PATCH}-3.1.7-flintconfig-r2.patch \
		"${FILESDIR}"/${PN_PATCH}-3.1.7-implicit-template.patch \
		"${FILESDIR}"/${PN_PATCH}-3.1.7-use_cxx_for_linking.patch \
		"${FILESDIR}"/${PN_PATCH}-3.1.7-curring.patch

	if has_version ">=dev-libs/ntl-9.0.2"; then
		# ccompatibility with ntl 8+
		epatch "${FILESDIR}"/${PN_PATCH}-3.1.7-ntl8.patch
	fi

	if  [[ ${CHOST} == *-darwin* ]] ; then
		# really a placeholder until I figure out the patch for that one.
		epatch "${FILESDIR}"/${PN_PATCH}-3.1.3.3-dylib.patch
		eprefixify Singular/Makefile.in
		sed -i -e "s|@LIB_DIR@|$(get_libdir)|g" Singular/Makefile.in
		sed -i -e "s:::"
	else
		epatch "${FILESDIR}"/${PN_PATCH}-3.1.3.3-soname.patch
	fi

	rm -rf ntl

	eprefixify kernel/feResource.cc Singular/configure.in factory/flint-check.m4
	if use prefix ; then
		sed -i -e "s:-lkernel -L../kernel -L../factory -L../libfac:-lkernel -L../kernel -L../factory -L../libfac -L${EPREFIX}/usr/$(get_libdir):" \
			Singular/Makefile.in
	fi

	SOSUFFIX=$(get_version_component_range 1-3)
	sed -i \
		-e "s:SO_SUFFIX = so:SO_SUFFIX = so.${SOSUFFIX}:" \
		"${S}"/Singular/Makefile.in || die

	cd "${S}"/Singular || die "failed to cd into Singular/"
	eautoconf
	cd "${S}"/factory || die "failed to cd into factory/"
	eautoconf
}

src_configure() {
	econf \
		--prefix="${S}"/build \
		--exec-prefix="${S}"/build \
		--bindir="${S}"/build/bin \
		--libdir="${S}"/build/lib \
		--libexecdir="${S}"/build/lib \
		--with-apint=gmp \
		--with-NTL \
		$(use_enable debug) \
		--disable-doc \
		--without-MP \
		--without-lex \
		--without-bison \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
		--enable-Singular \
		--with-malloc=system \
		--with-dynamic-kernel \
		$(use_with flint) \
		$(use_with boost Boost) || die "configure failed"
}

src_compile() {
	cd "${S}"/omalloc && emake install || die "making omalloc failed"
	cd "${S}"/factory && emake install || die "making factory failed"
	cd "${S}"/libfac && emake install || die "making libfac failed"
	cd "${S}"/kernel && emake install || die "making kernel failed"

	cd "${S}"
#	emake libsingular || die "emake libsingular failed"
}

src_test() {
	# Tests fail to link -lsingular, upstream ticket #243
	emake test || die "tests failed"
}

src_install () {
	dodoc README

	emake install-libsingular || die "failed to put libsingular in the right location"
	cd "${S}"/build/lib
	if  [[ ${CHOST} == *-darwin* ]] ; then
		dolib.so libsingular.dylib
	else
		dolib.so libsingular.so."${SOSUFFIX}"
		dosym libsingular.so."${SOSUFFIX}" /usr/$(get_libdir)/libsingular.so \
			|| die "failed to create symlink"
		dosym libsingular.so."${SOSUFFIX}" \
			/usr/$(get_libdir)/libsingular.so."$(get_major_version)" \
			|| die "failed to create symbolic link"
	fi
	insinto /usr/include
	cd "${S}"/build/include
	# Move factory headers in the singular folder so we don't either
	# collide with factory or need it to use libsingular.
	sed -e "s:<factory/:<singular/factory/:g" \
		-i `grep -rl "<factory/" *`

	doins libsingular.h mylimits.h omalloc.h
	insinto /usr/include/singular
	doins factor.h factory/factory.h factory/cf_gmp.h singular/*
	# This file is not copied by singular in the right place
	doins "${S}"/Singular/sing_dbm.h
	insinto /usr/include/singular/factory
	doins -r factory/*
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."

	einfo "libsingular include the functionality included by libfactory (factory ebuild)"
	einfo "To avoid file collisions with factory and the need of factory to use libsingular"
	einfo "We have moved the factory headers shipped by singular in /usr/include/singular."
	einfo "If you want to use the factory functionality offered by libsingular rather than"
	einfo "the one offered by the factory ebuild you should include singular/factor.h rather"
	einfo "than just factor.h."
}
