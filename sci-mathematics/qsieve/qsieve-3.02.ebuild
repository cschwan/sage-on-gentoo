# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="A program for factoring numbers"
HOMEPAGE="http://www.thorstenreinecke.de/qsieve/"
SRC_URI="http://www.thorstenreinecke.de/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.0.0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-programming-errors.patch
}
