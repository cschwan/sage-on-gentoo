# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Interfacing the geometry software polymake"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.10.1
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	sci-mathematics/polymake"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

DOCS="CHANGES README"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc lib
	doins *.g
}
