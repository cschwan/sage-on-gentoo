# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit toolchain-funcs

MY_PN="${PN}-src"

DESCRIPTION="An non-optimal 2x2x2 rubik's cube solver"
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
	emake CPP="$(tc-getCXX)" LINK="$(tc-getCXX)" CFLAGS="${CFLAGS}" \
		LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin cu2
	dodoc readme.txt
}
