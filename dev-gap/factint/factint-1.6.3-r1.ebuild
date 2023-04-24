# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN="FactInt"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Advanced Methods for Factoring Integers"
HOMEPAGE="https://www.gap-system.org/Packages/factint.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6"

S="${WORKDIR}/${MY_P}"

DOCS="README.md CHANGES"

GAP_PKG_OBJS="doc lib tables"
