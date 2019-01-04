# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Small Groups Library"
HOMEPAGE="http://www.gap-system.org/Packages/smallgrp.html"
SLOT="4.10.0"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${SLOT})/tar.bz2/gap-${SLOT}.tar.bz2"

LICENSE="Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/gap-${SLOT}/pkg/${P}"

DOCS="README.md"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap id* small*
	doins *.g
}
