# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
WANT_AUTOCONF="2.1" # Upstream ticket 240 -> wontfix

inherit autotools eutils flag-o-matic multilib prefix versionator

MY_PN=Singular
MY_PV=$(replace_all_version_separators -)
MY_DIR=$(get_version_component_range 1-3 ${MY_PV})
MY_PV_SHARE=${MY_PV}
PN_PATCH=singular

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_COM="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${MY_PN}"
SRC_URI="${SRC_COM}-${MY_PV}.tar.gz"

RESTRICT="mirror test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="boost debug"

RDEPEND="dev-libs/gmp
	>=dev-libs/ntl-5.5.1"

DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost )
	test? (
		dev-util/cmake
		dev-util/cppunit
	)"

S="${WORKDIR}"/${MY_PN}-${MY_DIR}

pkg_setup() {
	append-flags -fPIC -DLIBSINGULAR
	append-ldflags -fPIC
	tc-export CC CPP CXX
}

src_prepare () {
	epatch "${FILESDIR}"/${PN_PATCH}-3.1.0-gentoo.patch
	if  [[ ${CHOST} == *-darwin* ]] ; then
		# really a placeholder until I figure out the patch for that one.
		epatch "${FILESDIR}"/${PN_PATCH}-3.1.3.3-dylib.patch
		eprefixify Singular/Makefile.in
		sed -i -e "s|@LIB_DIR@|$(get_libdir)|g" Singular/Makefile.in
		sed -i -e "s:::"
	else
		epatch "${FILESDIR}"/${PN_PATCH}-3.1.3.3-soname.patch
	fi
	epatch "${FILESDIR}"/${PN_PATCH}-3.1.3.3-Minor.h.patch

	if  [[ ${CHOST} == *-darwin* ]] ; then
		epatch "${FILESDIR}"/${PN_PATCH}-3.1.3.3-os_x_ppc.patch
	fi
	rm -rf ntl

	eprefixify kernel/feResource.cc
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
}

src_configure() {
	econf \
		--prefix="${S}"/build \
		--exec-prefix="${S}"/build \
		--bindir="${S}"/build/bin \
		--libdir="${S}"/build/lib \
		--libexecdir="${S}"/build/lib \
		--with-apint=gmp \
		--with-gmp="${EPREFIX}"/usr \
		--enable-gmp="${EPREFIX}"/usr \
		--with-ntl="${EPREFIX}"/usr \
		--with-NTL \
		$(use_enable debug) \
		--disable-doc \
		--without-MP \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
		--enable-Singular \
		--with-malloc=system \
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

	cd "${S}"
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
	# Move factory.h and cf_gmp.h in the singular folder so we don't either
	# collide with factory or need it to use libsingular.
	sed -e "s:factory.h:singular/factory.h:" \
		-i singular/clapconv.h singular/fglm.h || die
	sed -e "s:factory/cf_gmp.h:singular/cf_gmp.h:" \
		-i factory.h || die
	sed -e "s:factory/factoryconf.h:singular/factoryconf.h:" \
		-e "s:factory/templates:singular/templates:g" \
		-i factory.h || die
	sed -e "s:factory/factoryconf.h:singular/factoryconf.h:" \
		-i templates/ftmpl_functions.h templates/ftmpl_list.h \
			templates/ftmpl_factor.h templates/ftmpl_matrix.h \
			templates/ftmpl_array.h || die
	sed -e "s:factory/templates:singular/templates:" \
		-i templates/ftmpl_list.cc templates/ftmpl_factor.cc || die
	sed -e "s:factoryconf.h:singular/factoryconf.h:" \
		-e "s:factory.h:singular/factory.h:" \
		-i templates/ftmpl_inst.cc || die
	sed -e "s:templates/ftmpl:singular/templates/ftmpl:" \
		-i templates/ftmpl_inst.cc || die

	doins libsingular.h mylimits.h omalloc.h
	insinto /usr/include/singular
	doins singular/*
	doins factory.h factoryconf.h cf_gmp.h
	insinto /usr/include/singular/templates
	doins templates/*
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."

	einfo "libsingular include the functionality included by libfactory (factory ebuild)"
	einfo "To avoid file collisions with factory and the need of factory to use libsingular"
	einfo "We have moved the factory headers shipped by singular in /usr/include/singular."
	einfo "If you want to use the factory functionality offered by libsingular rather than"
	einfo "the one offered by the factory ebuild you should include singular/factory.h rather"
	einfo "than just factory.h."
}
