# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Finding minimal and canonical images in permutation groups"
HOMEPAGE="https://gap-packages.github.io/images/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-mathematics/gap-4.12.0
	dev-gap/GAPDoc"

DOCS="README.md"

GAP_PKG_OBJS="doc gap"
