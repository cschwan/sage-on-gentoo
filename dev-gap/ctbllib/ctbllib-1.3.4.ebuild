# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="The GAP Character Table Library"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="mirror://sagemath/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6
	>=dev-gap/atlasrep-2.1"

DOCS="README.md"
HTML_DOCS=htm/*

GAP_PKG_OBJS="ctbltoc data dlnames doc doc2 gap4"
