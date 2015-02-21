# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils

DESCRIPTION="A cython library interface to gap for sage"
HOMEPAGE="https://bitbucket.org/vbraun/libgap"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="test"

DEPEND=">=dev-libs/gmp-5.0.2
	~sci-mathematics/gap-${PV}"
RDEPEND="${DEPEND}"

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
