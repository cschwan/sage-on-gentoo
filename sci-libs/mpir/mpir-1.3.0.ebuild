# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="MPIR is a library for arbitrary precision arithmetic"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE="cxx"

DEPEND=""
RDEPEND="${DEPEND}"

# TODO: add more USE-flags

src_configure() {
	econf \
		$(use_enable cxx) \
		|| "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS
}
