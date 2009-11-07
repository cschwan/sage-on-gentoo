# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Cliquer is a set of C routines for finding cliques in an arbitrary
weighted graph"
HOMEPAGE="http://users.tkk.fi/pat/cliquer.html"
SRC_URI="http://users.tkk.fi/~pat/cliquer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/bin
	doexe cl
}
