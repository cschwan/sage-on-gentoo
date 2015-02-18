# Copyright 1999-2015 Gentoo Foundation
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
	>=dev-libs/ntl-6.0.0
	>=sci-mathematics/pari-2.7.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/sage-${PV}/src/c_lib"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-6.2-SConstruct.patch

	sed -i "s:\$SAGE_LOCAL/lib:\$SAGE_LOCAL/$(get_libdir):" SConstruct

	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:-Wl,-soname,libcsage.so:-install_name ${EPREFIX}/usr/$(get_libdir)/libcsage.dylib:" \
			SConstruct || die "failed to patch"
	fi
}

src_install() {
	CXX= SAGE_LOCAL="${EPREFIX}"/usr DESTDIR=${D} escons install
}
