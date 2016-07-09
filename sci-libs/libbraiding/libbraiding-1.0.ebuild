# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Expose the functionalities of Braiding as a shared library"
HOMEPAGE="https://github.com/miguelmarco/libbraiding"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure(){
	econf \
		$(use_enable static-libs static)
}
