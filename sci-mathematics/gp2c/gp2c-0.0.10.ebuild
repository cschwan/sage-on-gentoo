# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A GP to C translator"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/pari/GP2C/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-mathematics/pari-2.9.0
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_configure(){
	econf \
		--with-paricfg="${EPREFIX}/usr/share/pari/pari.cfg"
}
