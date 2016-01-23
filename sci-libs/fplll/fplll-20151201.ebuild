# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Different implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/dstehle/fplll"
#SRC_URI="mirror://sageupstream/${PN}/${P}.tar.gz"
SRC_URI="http://sage.ugent.be/www/jdemeyer/sage/libfplll-20151201.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.2.0:0
	>=dev-libs/mpfr-2.3.0:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/src

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS NEWS" default
}
