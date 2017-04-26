# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="autotooled fork of cliquer"
HOMEPAGE="https://github.com/dimpase/autocliquer"
SRC_URI="https://github.com/dimpase/autocliquer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/auto${P}"

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	econf \
		$(use_enable static-libs static)
}

src_install(){
	default
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
