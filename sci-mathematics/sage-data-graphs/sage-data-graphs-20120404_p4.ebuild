# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator

MY_P="graphs-$(replace_version_separator 1 '.')"

DESCRIPTION="Sage's graph database"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}/src

src_install() {
	insinto /usr/share/sage/graphs
	doins graphs.db isgci_sage.xml
}
