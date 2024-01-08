# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="The GAP Small Groups Library"
HOMEPAGE="https://www.gap-system.org/Packages/smallgrp.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/smallgrp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Artistic-2"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6"

DOCS="README.md"

GAP_PKG_OBJS="doc gap id* small*"

pkg_postinst() {
	einfo "Disregard QA message about .la files."
	einfo "No libtool files are installed but one file installed in a tested location"
	einfo "has a matching extension by coincidence."
}
