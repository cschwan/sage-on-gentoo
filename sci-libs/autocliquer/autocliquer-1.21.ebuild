# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="autotooled fork of cliquer"
HOMEPAGE="https://github.com/dimpase/autocliquer"
SRC_URI="https://github.com/dimpase/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!!sci-libs/libcliquer"

src_prepare(){
	default

	eautoreconf
}
