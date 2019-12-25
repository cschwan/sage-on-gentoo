# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Different implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/fplll/fplll"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/4.0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.2.0:0
	>=dev-libs/mpfr-2.3.0:0"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install(){
	default
	# Removing la files
	find "${ED}" -name '*.la' -delete || die
}
