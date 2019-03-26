# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="libsemigroups is a C++ library for semigroups and monoids"
HOMEPAGE="https://james-d-mitchell.github.io/libsemigroups/"
SRC_URI="https://github.com/james-d-mitchell/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
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
