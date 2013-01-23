# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib scons-utils versionator

MY_P="sage-$(replace_version_separator 2 '.')"

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> sage-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~ppc-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp[cxx]
	>=dev-libs/ntl-5.5.2
	>=sci-libs/pynac-0.2.5
	~sci-mathematics/pari-2.5.3
	~sci-mathematics/polybori-0.8.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/c_lib"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.7.1-importenv.patch
	epatch "${FILESDIR}"/${PN}-4.5.3-fix-undefined-symbols-warning.patch

	sed -i "s:mpir.h:gmp.h:" src/memory.c || die "failed to patch"

	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:-Wl,-soname,libcsage.so:-install_name ${EPREFIX}/usr/$(get_libdir)/libcsage.dylib:" \
			SConstruct || die "failed to patch"
	fi
}

src_compile() {
	CXX= SAGE_LOCAL="${EPREFIX}"/usr UNAME=$(uname) escons
}

src_install() {
	dolib.so libcsage$(get_libname)
	insinto /usr/include/csage
	doins include/*.h
}
