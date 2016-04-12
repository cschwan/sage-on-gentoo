# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_PN="solver"

DESCRIPTION="An non-optimal 3x3x3 rubik's cube solver"
HOMEPAGE="http://www.wrongway.org/?rubiksource"
#SRC_URI="http://www.wrongway.org/work/${MY_PN}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://sagemath/${MY_PN}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

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
