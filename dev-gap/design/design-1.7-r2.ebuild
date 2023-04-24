# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="The Design Package for GAP"
HOMEPAGE="https://www.gap-system.org/Packages/design.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/grape-4.8.5
	>=dev-gap/GAPDoc-1.6.6"

DOCS="README.md CHANGES.md"

GAP_PKG_OBJS="doc lib"
