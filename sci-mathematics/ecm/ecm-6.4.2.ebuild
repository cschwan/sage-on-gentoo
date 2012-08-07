# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils flag-o-matic

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/30448/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="openmp shellcmd sse2 static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.2
	openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog NEWS README README.lib TODO )

pkg_setup(){
	if [[ ${CHOST} == *-linux* ]] ; then
		append-ldflags "-Wl,-z,noexecstack"
	fi
}

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
		--enable-asm-redc \
		$(use_enable openmp) \
		$(use_enable shellcmd) \
		$(use_enable sse2)
	)

	autotools-utils_src_configure
}
