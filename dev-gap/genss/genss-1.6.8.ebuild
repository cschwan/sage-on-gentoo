# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Generic Schreier-Sims"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6
	>=dev-gap/io-4.7.2
	>=dev-gap/orb-4.8.5"

DOCS="CHANGES README TODO"

GAP_PKG_OBJS="doc examples gap"
