# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Polycyclic presentations for matrix groups"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.10.1
	>=dev-gap/polycyclic-2.14
	>=dev-gap/radiroot-2.8
	>=dev-gap/Alnuth-3.1.0"

DOCS="README CHANGES"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc exam lib
	doins *.g
}
