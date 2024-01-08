# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Quivers and Path Algebras"
HOMEPAGE="https://folk.ntnu.no/oyvinso/QPA/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/gbnp-1.0.5"

DOCS="README CHANGES"

GAP_PKG_OBJS="doc examples lib"
