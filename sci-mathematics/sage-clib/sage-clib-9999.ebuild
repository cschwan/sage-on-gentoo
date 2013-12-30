# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib scons-utils versionator

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/sagemath/sage.git"
	EGIT_BRANCH=develop
	EGIT_SOURCEDIR="${WORKDIR}/sage-${PV}"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="mirror://sagemath/${PV}.tar.gz -> sage-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~ppc-macos ~x64-macos"
fi

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp[cxx]
	>=dev-libs/ntl-5.5.2
	~sci-libs/pynac-0.3.0
	>=sci-mathematics/pari-2.5.4
	>=sci-mathematics/polybori-0.8.3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/sage-${PV}/src/c_lib"

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
