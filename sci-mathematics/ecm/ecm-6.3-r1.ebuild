# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/26838/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="openmp shellcmd sse2 static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.2
	openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog NEWS README README.lib TODO )

src_prepare() {
	# TODO: report problem to upstream
	if use openmp ; then
		sed -i "s:libecm_la_LIBADD = :libecm_la_LIBADD = -lgomp :" Makefile.am \
			|| die "failed to fix Makefile.am"
	fi

	eautoreconf
	autotools-utils_src_prepare
}

src_configure() {
	# TODO: fix assembler files on all platforms to re-enable asm-redc
	myeconfargs=(
# 		$(use_enable asm-redc) \
		$(use_enable openmp) \
		$(use_enable shellcmd) \
		$(use_enable sse2)
	)

	autotools-utils_src_configure
}
