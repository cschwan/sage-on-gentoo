# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit eutils

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/22124/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

src_install() {
	# TODO: needed for x86 ?
	CFLAGS="${CFLAGS} -fPIC"
	CXXFLAGS="${CXXFLAGS} -fPIC"

	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS README README.lib TODO || die "dodoc failed"
}
