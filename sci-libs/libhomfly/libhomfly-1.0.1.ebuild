# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools versionator

MY_PV=$(replace_version_separator 2 r)
DESCRIPTION="Library to compute the homfly polynomial of a link"
HOMEPAGE="https://github.com/miguelmarco/libhomfly"
SRC_URI="https://github.com/miguelmarco/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

src_prepare(){
	default
	# github tarball doesn't have generated configure, etc...
	eautoreconf
}

src_configure(){
	econf \
		$(use_enable static-libs static)
}
