# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

Parent_PN="p_group_cohomology"
Parent_PV="3.3.2"
Parent_P="${Parent_PN}-${Parent_PV}"
DESCRIPTION="p_group_cohomology helper library"
HOMEPAGE="https://users.fmi.uni-jena.de/cohomology/"
SRC_URI="https://github.com/sagemath/${Parent_PN}/releases/download/v${Parent_PV}/${Parent_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sci-mathematics/shared_meataxe"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-1.1-test.patch )

S="${WORKDIR}/${Parent_P}/${P}"

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
