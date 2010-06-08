# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils flag-o-matic

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/22124/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="asm-redc debug openmp shellcmd sse2"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.2
	openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-6.2.3-configure.patch
	epatch "${FILESDIR}"/${PN}-6.2.3-makefile.patch
	epatch "${FILESDIR}"/${PN}-6.2.3-execstack.patch
	epatch "${FILESDIR}"/${PN}-6.2.3-execstack-redc.patch

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable asm-redc) \
		$(use_enable debug memory-debug) \
		$(use_enable debug assert) \
		$(use_enable openmp) \
		$(use_enable shellcmd) \
		$(use_enable sse2) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS README README.lib TODO || die "dodoc failed"
}
