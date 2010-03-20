# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit flag-o-matic python

# TODO: Homepage ?

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by
Python"
# HOMEPAGE=""
SRC_URI="mirror://sage/spkg/standard/${P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

CDEPEND="virtual/python"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/src"

src_configure() {
	# add missing include path
	append-cppflags -I$(python_get_includedir)

	econf || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
