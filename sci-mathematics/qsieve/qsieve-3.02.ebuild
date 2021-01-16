# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A program for factoring numbers"
HOMEPAGE="https://www.thorstenreinecke.de/qsieve/"
SRC_URI="https://www.thorstenreinecke.de/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc cpu_flags_x86_sse2"

RESTRICT=primaryuri

CDEPEND="dev-libs/gmp:="
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.02-fix-programming-errors.patch
	)

src_configure() {
	econf \
		$(use_enable doc reference-manual) \
		$(use_enable cpu_flags_x86_sse2 SSE2)
}
