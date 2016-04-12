# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_PN="FlintQS"
DESCRIPTION="William Hart's GPL'd multi-polynomial quadratic sieve for integer factorization"
HOMEPAGE="https://github.com/sagemath/${MY_PN}"
SRC_URI="https://github.com/sagemath/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp:="
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_PN}-${PV}

src_prepare(){
	default

	eautoreconf
}
