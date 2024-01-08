# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Nilpotent Quotients of Finitely Presented Groups"
HOMEPAGE="https://gap-packages.github.io/nq/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-mathematics/gap-4.12.0:=
	dev-libs/gmp:0="
RDEPEND="${DEPEND}
	>=dev-gap/polycyclic-2.16"

DOCS="CHANGES README.md TODO"

GAP_PKG_OBJS="doc examples gap"

src_configure() {
	econf \
		--bindir="/$(gap-pkg_path)/bin/$(gap-pkg_gaparch)" \
		--with-gaproot="$(gap_sysinfo_loc)" \
		ABI=""
}
