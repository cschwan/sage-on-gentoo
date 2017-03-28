# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_PN="edge-addition-planarity-suite-Version"
DESCRIPTION="This code project provides a library for implementing graph algorithms"
HOMEPAGE="https://code.google.com/p/planarity/"
SRC_URI="https://github.com/graph-algorithms/edge-addition-planarity-suite/archive/Version_3.0.0.5.tar.gz -> ${P}.tar.gz"
IUSE="static-libs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-extern.patch
	)

S="${WORKDIR}"/${MY_PN}_${PV}

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	econf \
		$(use_enable static-libs static)
}
