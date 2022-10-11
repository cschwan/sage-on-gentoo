# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Homological Algebra Programming"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-core-4.11.1
	>=dev-gap/aclib-1.3.1
	>=dev-gap/polycyclic-2.14
	>=dev-gap/crystcat-1.1.9
	>=dev-gap/fga-1.4.0
	>=dev-gap/nq-2.5.4"

DOCS="README.md"
HTML_DOCS=www/*

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc lib
	doins *.g boolean version
}

pkg_postinst(){
	elog "Some optional functions, require the following"
	elog "dependencies to be installed at runtime:"
	elog ""
	elog "sci-mathematics/polymake"
	elog "media-gfx/graphviz"
}
