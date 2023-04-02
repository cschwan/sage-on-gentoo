# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Almost Crystallographic Groups - A Library and Algorithms"
HOMEPAGE="https://www.gap-system.org/Packages/aclib.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.2"

HTML_DOCS=htm/*
DOCS="README"

GAP_PKG_OBJS="doc gap"
