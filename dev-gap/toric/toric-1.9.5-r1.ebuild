# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN="Toric"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="toric varieties and some combinatorial geometry computations"
HOMEPAGE="https://www.gap-system.org/Packages/toric.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.0"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES README.md"

GAP_PKG_OBJS="doc lib"
