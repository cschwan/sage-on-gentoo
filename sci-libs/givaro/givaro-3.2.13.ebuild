# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/Downloads/${P}.tar.gz"

LICENSE="CeCILL-B GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-3.1.1"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--with-gmp=/usr \
		--enable-shared \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog
}
