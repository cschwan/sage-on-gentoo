# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP Primitive Permutation Groups Library"
HOMEPAGE="https://www.gap-system.org/Packages/primgrp.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.2
	>=dev-gap/GAPDoc-1.6.6"

DOCS="README.md CHANGES.md"

GAP_PKG_OBJS="data doc lib"
