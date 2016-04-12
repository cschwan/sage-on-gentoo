# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An optimal rubik's cube solver using God's Algorithm"
HOMEPAGE="http://www.permutationpuzzles.org/rubik/"
SRC_URI="http://www.permutationpuzzles.org/rubik/software/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	$(tc-getCC) ${CFLAGS} -c optimal.c -o optimal.o
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o optimal optimal.o
}

src_install() {
	dobin optimal
	dodoc README
}
