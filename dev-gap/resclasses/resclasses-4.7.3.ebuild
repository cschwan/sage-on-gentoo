# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Set-Theoretic Computations with Residue Classes"
HOMEPAGE="https://www.gap-system.org/Packages/resclasses.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6
	>=dev-gap/utils-0.76
	>=dev-gap/polycyclic-2.16"

DOCS="CHANGES README"

GAP_PKG_OBJS="doc lib"
