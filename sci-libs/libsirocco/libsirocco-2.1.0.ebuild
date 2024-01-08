# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sirocco Is a ROot Certified COntinuator"
HOMEPAGE="https://github.com/miguelmarco"
SRC_URI="https://github.com/miguelmarco/SIROCCO2/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-libs/gmp:=
	dev-libs/mpfr:="
RDEPEND="${DEPEND}"

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
