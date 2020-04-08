# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Interfacing the geometry software polymake"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.10.0
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	sci-mathematics/polymake"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${PN}"

DOCS="CHANGES.polymaking README.polymaking"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc lib tst
	doins *.g
}
