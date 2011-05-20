# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit toolchain-funcs

MY_PN="${PN}10-src"

DESCRIPTION="An non-optimal 4x4x4 rubik's cube solver"
HOMEPAGE="http://www.wrongway.org/?rubiksource"
SRC_URI="http://www.wrongway.org/work/${MY_PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	emake CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}" CPP="$(tc-getCXX)" \
		LINK="$(tc-getCXX)"
}

src_install() {
	dobin mcube
	dodoc readme.txt
}
