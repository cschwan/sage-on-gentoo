# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/gmp-3.1.1
	>=sci-libs/blas-atlas-3.0"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README
}
