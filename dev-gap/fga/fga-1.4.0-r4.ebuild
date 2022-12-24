# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Free Group Algorithms"
HOMEPAGE="https://www.gap-system.org/Packages/fga.html"
SLOT="0"
SRC_URI="https://github.com/chsievers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0"

DOCS="README"

GAP_PKG_OBJS="doc lib"
