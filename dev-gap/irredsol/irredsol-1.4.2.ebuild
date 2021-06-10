# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Irreducible soluble linear groups over finite fields and more"
HOMEPAGE="https://github.com/bh11/irredsol"
SLOT="0"
SRC_URI="https://github.com/bh11/${PN}/releases/download/IRREDSOL-${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( >=sci-mathematics/gap-core-4.11.1 >=sci-mathematics/gap-4.11.1 )"

DOCS="README.txt LICENSE.txt"
HTML_DOCS=htm/*

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc fp lib
	doins *.g
}
