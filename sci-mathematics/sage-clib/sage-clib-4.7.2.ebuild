# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7:2.7"
inherit eutils versionator multilib python

MY_P="sage-$(replace_version_separator 3 '.')"

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RESTRICT="mirror"

CDEPEND="dev-libs/gmp[cxx]
	>=dev-libs/ntl-5.5.2
	=sci-libs/pynac-0.2.3
	>=sci-mathematics/pari-2.5.0
	>=sci-mathematics/polybori-0.7.1[sage]"
DEPEND="${CDEPEND}
	dev-util/scons"
RDEPEND="${CDEPEND}"
RESTRICT_PYTHON_ABIS="2.[456] 3.*"

S="${WORKDIR}/${MY_P}/c_lib"

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.7.1-importenv.patch
	epatch "${FILESDIR}"/${PN}-4.5.3-fix-undefined-symbols-warning.patch

	sed -i "s:mpir.h:gmp.h:" src/memory.c

	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:-Wl,-soname,libcsage.so:-install_name ${EPREFIX}/usr/$(get_libdir)/libcsage.dylib:" \
			SConstruct
	fi
}

src_compile() {
	# build libcsage.so
	CXX= SAGE_LOCAL="${EPREFIX}"/usr UNAME=$(uname) "$(PYTHON)" "${EPREFIX}"/usr/bin/scons
}

src_install() {
	dolib.so libcsage$(get_libname) || die
	insinto /usr/include/csage
	doins include/*.h || die
}
