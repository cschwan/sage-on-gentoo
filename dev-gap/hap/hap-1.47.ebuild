# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Homological Algebra Programming"
HOMEPAGE="https://www.gap-system.org/Packages/hap.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/aclib-1.3.2
	>=dev-gap/polycyclic-2.16
	>=dev-gap/crystcat-1.1.10
	>=dev-gap/fga-1.4.0-r4
	>=dev-gap/nq-2.5.8"

DOCS="README.md"
HTML_DOCS="www/* tutorial"

GAP_PKG_OBJS="doc lib"

pkg_postinst() {
	elog "Some optional functions, require the following"
	elog "dependencies to be installed at runtime:"
	elog ""
	elog "sci-mathematics/polymake"
	elog "media-gfx/graphviz"
}
