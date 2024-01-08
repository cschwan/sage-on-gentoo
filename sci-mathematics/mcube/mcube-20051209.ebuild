# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="${PN}10-src"

DESCRIPTION="An non-optimal 4x4x4 rubik's cube solver"
HOMEPAGE="https://web.archive.org/web/20121212175710/http://www.wrongway.org/?rubiksource"
SRC_URI="mirror://sagemath/${MY_PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_compile() {
	emake CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}" CPP="$(tc-getCXX)" \
		LINK="$(tc-getCXX)"
}

src_install() {
	dobin mcube
	dodoc readme.txt
}
