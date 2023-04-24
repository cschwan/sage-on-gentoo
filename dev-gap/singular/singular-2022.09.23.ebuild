# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="gap interface to sci-mathematics/singular"
HOMEPAGE="https://gap-packages.github.io/singular/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-mathematics/gap-4.12.1
	sci-mathematics/singular"

DOCS="CHANGES.md README.md"

GAP_PKG_OBJS="contrib doc gap lib"
