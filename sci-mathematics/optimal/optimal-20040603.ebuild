# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit toolchain-funcs

MY_P="optimal"

DESCRIPTION="An optimal rubik's cube solver using God's Algorithm"
HOMEPAGE="http://www.math.ucf.edu/~reid/Rubik/optimal_solver.html"
SRC_URI="http://www.math.ucf.edu/~reid/Rubik/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
	$(tc-getCC) ${CFLAGS} optimal.c -o optimal
}

src_install() {
	dobin optimal
	dodoc README
}
