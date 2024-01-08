# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_PN="solver"

DESCRIPTION="An non-optimal 3x3x3 rubik's cube solver"
HOMEPAGE="https://web.archive.org/web/20121212175710/http://www.wrongway.org/?rubiksource"
SRC_URI="mirror://sagemath/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-fix-missing-include.patch
	)

S="${WORKDIR}/${MY_PN}"

src_compile() {
	emake CC="$(tc-getCXX)" LINK="$(tc-getCXX)" CFLAGS="${CFLAGS}" \
		LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin cubex
	dodoc readme.txt
}
