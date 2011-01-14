# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils scons-utils versionator multilib

MY_P="sage-${PV}"

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp[-nocxx]
	>=dev-libs/ntl-5.5.2
	>=sci-libs/pynac-0.2.1
	sci-mathematics/pari:3
	>=sci-mathematics/polybori-0.6.5-r2[sage]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/c_lib"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.6-importenv.patch
	epatch "${FILESDIR}"/${PN}-4.5.3-fix-undefined-symbols-warning.patch
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:-Wl,-soname,libcsage.so:-install_name ${EPREFIX}/usr/$(get_libdir)/libcsage.dylib:" \
			SConstruct
	fi

	# Use pari-2.4
	sed -i "s:pari/:pari24/:" include/convert.h || die "failed to use pari2.4 headers"
}

src_compile() {
	# build libcsage.so
	CXX= SAGE_LOCAL="${EPREFIX}"/usr UNAME=$(uname) escons || die
}

src_install() {
	dolib.so libcsage$(get_libname) || die
	insinto /usr/include/csage
	doins include/*.h || die
}
