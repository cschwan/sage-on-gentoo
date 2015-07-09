# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ntl/ntl-6.1.0.ebuild,v 1.1 2014/06/16 21:54:20 jauhien Exp $

EAPI=5
inherit toolchain-funcs eutils multilib flag-o-matic

DESCRIPTION="High-performance and portable Number Theory C++ library"
HOMEPAGE="http://shoup.net/ntl/"
SRC_URI="http://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc static-libs test"

RDEPEND="dev-libs/gmp:=
	>=dev-libs/gf2x-0.9"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}/src"

src_prepare() {
	# Add controls to build static library or not. Sanitize the use of make
	# and split the install target for the documentation.
	epatch "${FILESDIR}"/${PN}-6.2.1-static_and_sanity.patch
	# multilib fix
	sed -i -e "s:\$(PREFIX)/lib:\$(PREFIX)/$(get_libdir):g" DoConfig
	cd ..
	# enable compatibility with singular
	epatch "${FILESDIR}"/${PN}-6.0.0-singular.patch
	# implement a call back framework (submitted upstream)
	epatch "${FILESDIR}"/${PN}-6.0.0-sage-tools.patch
	replace-flags -O[3-9] -O2
}

src_configure() {
	# control the building of the static library
	local BUILDSTATIC="off"
	use static-libs && BUILDSTATIC="on"

	perl DoConfig \
		PREFIX="${EPREFIX}"/usr \
		CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		CXX="$(tc-getCXX)" SHARED=on \
		AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		NTL_STD_CXX=on NTL_GMP_LIP=on NTL_GF2X_LIB=on \
		STATIC="${BUILDSTATIC}" \
		|| die "DoConfig failed"
}

src_compile() {
	tc-export CC
	# split the targets to allow parallel make to run properly
	emake setup1 setup2 || die "emake setup failed"
	emake setup3 || die "emake setup failed"
	sh Wizard on || die "Tuning wizard failed"
	# this target now can build both shared and static libraries
	emake ntl.a  || die "emake failed to build the libraries"
}

src_install() {
	emake PREFIX="${ED}usr" install
	if use doc; then
		emake PREFIX="${ED}usr" install-doc
	fi
}
