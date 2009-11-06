# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="M4RI is a library for fast arithmetic with dense matrices over F2"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="http://m4ri.sagemath.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="openmp"

# TODO: debug, cachetune, doc(doxygen) ?

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use openmp && use_enable openmp) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
