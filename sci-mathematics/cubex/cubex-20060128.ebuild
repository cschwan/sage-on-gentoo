# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

MY_PN="solver"

DESCRIPTION="An non-optimal 3x3x3 rubik's cube solver"
HOMEPAGE="http://www.wrongway.org/?rubiksource"
SRC_URI="http://www.wrongway.org/work/${MY_PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-missing-include.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin cubex || die
	dodoc readme.txt || die
}
