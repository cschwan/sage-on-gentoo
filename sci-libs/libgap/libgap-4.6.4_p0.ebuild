# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils versionator

DESCRIPTION="A cython library interface to gap for sage"
HOMEPAGE="https://bitbucket.org/vbraun/libgap"
MY_P=libgap-$(replace_version_separator 3 '.')
GAP_PV=$(get_version_component_range 1-3)
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="test"

DEPEND=">=dev-libs/gmp-5.0.2
	|| ( ~sci-mathematics/gap-${GAP_PV} ~sci-mathematics/gap-lite-${GAP_PV} )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"/src
AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare(){
	sed -e "s:src/compiled.h:compiled.h:" \
		-i src/compiler.c

	autotools-utils_src_prepare
}

src_configure(){

	source "${EPREFIX}"/etc/sysinfo.gap

	local myeconfargs=(
		--with-sage="${EPREFIX}"/usr
		--with-gap_system_arch=$GAParch_system
		)

	autotools-utils_src_configure
}
