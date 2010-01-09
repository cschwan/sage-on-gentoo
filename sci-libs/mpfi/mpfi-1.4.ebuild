# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

# TODO: Official description is: MPFI est une bibliotheque C d'arithmetique par
# intervalles multi-precision basee sur les bibliotheques MPFR et GMP. Is my
# description correct ?

DESCRIPTION="a multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="http://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI="http://gforge.inria.fr/frs/download.php/22256/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.1.2
	>=dev-libs/mpfr-2.0.1"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-gmp-dir=/usr \
		--with-mpfr-dir=/usr \
		|| die "econf failed"
}

# TODO: no tests, but a test target ?

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS
}
