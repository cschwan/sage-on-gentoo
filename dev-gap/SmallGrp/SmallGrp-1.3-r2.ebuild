# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Small Groups Library"
HOMEPAGE="http://www.gap-system.org/Packages/smallgrp.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/smallgrp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.10.1"

DOCS="README.md"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap id* small*
	doins *.g
}
