# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nilpotent Quotients of Finitely Presented Groups"
HOMEPAGE="https://gap-packages.github.io/nq/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-core-4.11.1
	dev-libs/gmp:0="
RDEPEND="${DEPEND}
	>=dev-gap/polycyclic-2.14"

DOCS="CHANGES README.md"

src_configure(){
	# We need to know GAParch to install the executable in the right location
	# "doins -r bin" would install it non-executable
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--bindir="${EPREFIX}/usr/share/gap/pkg/${P}/bin/${GAParch}" \
		--with-gaproot="${EPREFIX}/usr/share/gap" \
		ABI=""
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc examples gap
	doins *.g
}
