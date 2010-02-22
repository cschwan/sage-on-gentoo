# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=4.3.3
SAGE_PACKAGE=${P}

inherit flag-o-matic python sage

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by
Python"
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

CDEPEND="virtual/python"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

src_configure() {
	# add missing include path
	append-cppflags -I$(python_get_includedir)

	econf || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
