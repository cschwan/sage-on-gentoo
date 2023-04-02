# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

Parent_PN="p_group_cohomology"
Parent_PV="3.3.2"
Parent_P="${Parent_PN}-${Parent_PV}"
DESCRIPTION="GAP helper for p_group_cohomology SageMath package"
HOMEPAGE="https://users.fmi.uni-jena.de/~king/index.html"
SRC_URI="https://github.com/sagemath/${Parent_PN}/releases/download/v${Parent_PV}/${Parent_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sci-mathematics/gap-4.12.2"

DOCS="README.md"

S="${WORKDIR}/${Parent_P}/gap_helper"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r gap
	doins *.g
}
