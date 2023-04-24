# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="A GAP Interface to the Atlas of Group Representations"
HOMEPAGE="https://www.gap-system.org/Packages/atlasrep.html"
SLOT="0"
SRC_URI="mirror://sagemath/${P}.tar.gz"
RESTRICT=mirror

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6
	>=dev-gap/io-4.7.2
	>=dev-gap/utils-0.77"

DOCS="README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5_p0-local.patch
	)

GAP_PKG_OBJS="bibl dataext datagens datapkg dataword doc gap atlasprm.json atlasprm_SHA.json"
