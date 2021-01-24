# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="latte-int(egrale) consists of tools for lattice point enumeration"
HOMEPAGE="https://github.com/latte-int/latte"
SRC_URI="https://github.com/${PN}/latte/releases/download/version_$(ver_rs 1-2 _)/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="
	dev-libs/gmp:0=[cxx]
	>=dev-libs/ntl-5.4.2
	sci-mathematics/4ti2
	sci-mathematics/topcom
	>=sci-libs/cddlib-094f"
RDEPEND="${DEPEND}"

src_configure(){
	econf \
		$(use_enable static-libs static) \
		--with-gmp \
		--with-ntl \
		--with-cddlib \
		--with-4ti2 \
		--with-topcom
}

src_install(){
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
