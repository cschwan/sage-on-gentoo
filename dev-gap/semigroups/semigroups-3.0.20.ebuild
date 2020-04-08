# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A package for semigroups and monoids"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}
	>=sci-libs/libsemigroups-0.6.4"
RDEPEND="${DEPEND}
	dev-gap/orb:${SLOT}
	dev-gap/io:${SLOT}
	dev-gap/digraphs:${SLOT}
	dev-gap/genss:${SLOT}"

DOCS="CHANGELOG.md README.md CONTRIBUTING.md"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.20-system_pkg.patch
	)

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	# We need to know GAParch to install the dynamic object in the expected location
	# "doins -r bin" would install it with wrong permissions
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--libdir="${EPREFIX}/usr/share/gap/pkg/${P}/bin/${GAParch}" \
		--with-gaproot="${EPREFIX}/usr/share/gap" \
		LIBS="-lsemigroups -lgap" \
		ABI=""
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc gap
	doins *.g
}
