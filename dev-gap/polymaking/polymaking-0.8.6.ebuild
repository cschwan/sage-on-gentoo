# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Interfacing the geometry software polymake"
HOMEPAGE="https://www.gap-system.org/Packages/polymaking.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	sci-mathematics/polymake"

DOCS="CHANGES.md README.md"

GAP_PKG_OBJS="doc lib"
