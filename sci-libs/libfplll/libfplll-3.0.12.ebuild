# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="fpLLL-3.0 contains several algorithms on lattices that rely on
floating-point computations"
HOMEPAGE="http://perso.ens-lyon.fr/damien.stehle/"
SRC_URI="http://perso.ens-lyon.fr/damien.stehle/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/gmp-4.2.0
	>=dev-libs/mpfr-2.3.0"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--includedir=/usr/include/fplll \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README || die "dodoc failed"
}
