# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An optimal rubik's cube solver using God's Algorithm"
HOMEPAGE="https://www.permutationpuzzles.org/rubik/"
#SRC_URI="https://www.permutationpuzzles.org/rubik/software/${PN}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://sagemath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RESTRICT=primaryuri

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
