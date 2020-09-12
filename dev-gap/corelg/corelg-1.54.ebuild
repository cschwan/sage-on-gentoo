# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="computation with real Lie groups"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.10.1
	>=dev-gap/sla-1.5.1"

DOCS="README.md CHANGES.md"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc gap
	doins *.g
}
