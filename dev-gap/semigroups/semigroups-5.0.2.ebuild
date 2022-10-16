# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg flag-o-matic toolchain-funcs

DESCRIPTION="A package for semigroups and monoids"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/semigroups/Semigroups/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.12.0:=
	>=sci-libs/libsemigroups-2.2.1:="
RDEPEND="${DEPEND}
	>=dev-gap/orb-4.8.2
	>=dev-gap/io-4.5.4
	>=dev-gap/images-1.3.1
	>=dev-gap/datastructures-0.2.5
	>=dev-gap/digraphs-1.5.0
	>=dev-gap/genss-1.6.5"
BDEPEND="virtual/pkgconfig"

DOCS="CHANGELOG.md README.md CONTRIBUTING.md"

GAP_PKG_OBJS="data doc gap"

pkg_setup() {
	# work around that should go to libsemigroups
	append-cppflags $($(tc-getPKG_CONFIG) --cflags eigen3 || die)
}

src_configure() {
	econf \
		--with-external-libsemigroups \
		--libdir="${ESYSROOT}/$(gap-pkg_path)/bin/$(gap-pkg_gaparch)" \
		--with-gaproot="$(gap_sysinfo_loc)" \
		LIBS="-lgap" \
		ABI=""
}
