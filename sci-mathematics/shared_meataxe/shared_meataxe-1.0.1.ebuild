# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library and set of programs for working with matrices over finite fields"
HOMEPAGE="http://users.minet.uni-jena.de/~king/SharedMeatAxe/
	https://github.com/simon-king-jena/SharedMeatAxe/"
SRC_URI="https://github.com/simon-king-jena/SharedMeatAxe/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure(){
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
