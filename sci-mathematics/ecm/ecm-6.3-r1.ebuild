# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/22124/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="asm-redc openmp shellcmd sse2 static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.2
	openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND="${DEPEND}"

# Who made that release?
S="${WORKDIR}/${PN}-6.2.3"

DOCS=( ChangeLog NEWS README README.lib TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-6.2.3-configure.patch
	"${FILESDIR}"/${PN}-6.2.3-makefile.patch
	"${FILESDIR}"/${PN}-6.2.3-execstack.patch
	"${FILESDIR}"/${PN}-6.2.3-execstack-redc.patch
)

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf

	# fixes for gmp-5
	sed -i "s:__GMP_BITS_PER_MP_LIMB:GMP_LIMB_BITS:g" bestd.c mpmod.c \
		schoen_strass.c sp.h || die "failed to patch files for gmp-5"
}

src_configure() {
	myeconfargs=(
		$(use_enable asm-redc) \
		$(use_enable openmp) \
		$(use_enable shellcmd) \
		$(use_enable sse2)
	)

	autotools-utils_src_configure
}
