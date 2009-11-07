# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit eutils

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

# TODO: additional dependencies

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc HISTORY
}
