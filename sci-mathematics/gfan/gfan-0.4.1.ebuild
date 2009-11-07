# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit eutils

# TODO: Gröbner instead of Groebner ?

DESCRIPTION="Gfan is a software package for computing Groebner fans and tropical
varieties"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/${PN}0.4plus.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sci-libs/cddlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}0.4plus"

src_install() {
	emake PREFIX="${D}/usr" install || die "emake install failed"
}
