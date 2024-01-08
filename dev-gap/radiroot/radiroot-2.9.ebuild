# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computing with Radicals, Injectors, Schunck classes and Projectors"
HOMEPAGE="https://www.gap-system.org/Packages/radiroot.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/Alnuth-3.2.1"

DOCS="README CHANGES"
HTML_DOCS="htm"

GAP_PKG_OBJS="doc lib"
