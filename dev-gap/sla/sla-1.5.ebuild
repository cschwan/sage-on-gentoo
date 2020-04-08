# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a package for doing computations with simple Lie algebras"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/quagroup:${SLOT}"

DOCS="README.sla"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${PN}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc gap
	doins *.g
}
