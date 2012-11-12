# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.7:2.7"
RESTRICT_PYTHON_ABIS="2.[456] 3.*"

inherit eutils multilib python versionator

MY_P="sage-$(replace_version_separator 2 '.')"

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${MY_P}/${MY_P}/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~ppc-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

CDEPEND="dev-libs/gmp[cxx]
	>=dev-libs/ntl-5.5.2
	~sci-libs/pynac-0.2.5
	~sci-mathematics/pari-2.5.3
	~sci-mathematics/polybori-0.8.2"
DEPEND="${CDEPEND}
	dev-util/scons"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}/c_lib"

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

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
	# build libcsage.so
	CXX= SAGE_LOCAL="${EPREFIX}"/usr UNAME=$(uname) "$(PYTHON)" \
		"${EPREFIX}"/usr/bin/scons || die "failed to compile"
}

src_install() {
	dolib.so libcsage$(get_libname)
	insinto /usr/include/csage
	doins include/*.h
}
