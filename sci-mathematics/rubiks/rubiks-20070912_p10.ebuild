# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit versionator

MY_P="${PN}-$(replace_version_separator 1 '.')"

# TODO: Homepage ?

DESCRIPTION="A collection of programs solving rubik's cube"
# HOMEPAGE=""
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_compile() {
	cd "${S}"/dietz/cu2
	emake || die "emake failed"

	cd "${S}"/dietz/mcube
	emake || die "emake failed"

	cd "${S}"/dietz/solver
	emake || die "emake failed"

	cd "${S}"/dik
	emake all || die "emake failed"

	cd "${S}"/reid
	emake || die "emake failed"
}

src_install() {
	dobin dietz/cu2/cu2 || die "dobin failed"
	dobin dietz/mcube/mcube || die "dobin failed"
	dobin dietz/solver/cubex || die "dobin failed"
	dobin dik/dikcube || die "dobin failed"
	dobin dik/size222 || die "dobin failed"
	dobin reid/optimal || die "dobin failed"

	newdoc dietz/cu2/readme.txt README.cu2 || die "newdoc failed"
	newdoc dietz/mcube/readme.txt README.mcube || die "newdoc failed"
	newdoc dietz/solver/readme.txt README.solver || die "newdoc failed"
	newdoc dik/README README.dik || die "newdoc failed"
	newdoc reid/README README.reid || die "newdoc failed"
}
