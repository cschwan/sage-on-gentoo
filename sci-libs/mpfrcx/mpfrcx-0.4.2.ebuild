# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mpfrcx is a library for the arithmetic of univariate polynomials "
HOMEPAGE="http://www.multiprecision.org/mpfrcx/home.html"
SRC_URI="http://www.multiprecision.org/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-libs/gmp:0
	dev-libs/mpfr:0
	dev-libs/mpc"
RDEPEND="${DEPEND}"

RESTRICT=primaryuri

src_configure(){
	econf \
		$(use_enable static-libs static)
}
