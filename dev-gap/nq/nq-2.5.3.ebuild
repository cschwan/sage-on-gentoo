# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Nilpotent Quotients of Finitely Presented Groups"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}
	dev-libs/gmp:0="
RDEPEND="${DEPEND}
	dev-gap/polycyclic:${SLOT}"

DOCS="CHANGES README TODO"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.3-m4.patch
	)

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	# We need to know GAParch to install the executable in the right location
	# "doins -r bin" would install it non-executable
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--bindir="${EPREFIX}/usr/share/gap/pkg/${P}/bin/${GAParch}" \
		--with-gaproot="${EPREFIX}/usr/share/gap" \
		--with-gmp=system \
		ABI=""
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc examples gap
	doins *.g
}
