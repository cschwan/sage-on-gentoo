# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="combinatorial_designs"
MY_P="${MY_PN}-$(ver_rs 1 '.')"

DESCRIPTION="Data for Combinatorial Designs"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto /usr/share/sage/combinatorial_designs
	doins *
}
