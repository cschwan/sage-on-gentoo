# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator

MY_P="${PN}-$(replace_version_separator 3 '.')"

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://sagemath.org/ http://www.ginac.de/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

CDEPEND="virtual/python"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README || die "dodoc failed"
}
