# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Polycyclic presentations for matrix groups"
HOMEPAGE="https://www.gap-system.org/Packages/polenta.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/polycyclic-2.16
	>=dev-gap/radiroot-2.9
	>=dev-gap/Alnuth-3.2.1"

DOCS="README.md CHANGES TODO"

GAP_PKG_OBJS="doc exam lib"
