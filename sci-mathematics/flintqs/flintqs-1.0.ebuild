# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_PN="FlintQS"
DESCRIPTION="William Hart's GPL'd multi-polynomial quadratic sieve for integer factorization"
HOMEPAGE="https://github.com/sagemath/${MY_PN}"
SRC_URI="https://github.com/sagemath/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND="dev-libs/gmp:="
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_PN}-${PV}

src_prepare(){
	default

	eautoreconf
}
