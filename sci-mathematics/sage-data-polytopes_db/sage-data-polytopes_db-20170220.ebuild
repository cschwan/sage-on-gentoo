# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="polytopes_db"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sage's polytopes database"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto /usr/share/sage/reflexive_polytopes
	doins -r *
}
