# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://sagemath.org/ http://www.ginac.de/"
#SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"
SAGE_DIR="sage-4.6.alpha3"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_DIR}/${SAGE_DIR}/spkg/standard/${P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

RESTRICT="mirror"

CDEPEND="virtual/python"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/src"

DOCS=( AUTHORS NEWS README )
