# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Computing with quasigroups and loops in GAP"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( =sci-mathematics/gap-4.10* >=sci-mathematics/gap-core-4.11.0 )"

DOCS="README"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc gap
	doins *.g
}
