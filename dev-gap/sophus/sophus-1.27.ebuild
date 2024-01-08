# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computing in nilpotent Lie algebras"
HOMEPAGE="https://www.gap-system.org/Packages/sophus.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/autpgrp-1.11"

DOCS="README"

GAP_PKG_OBJS="doc gap"
