# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib

DESCRIPTION="Computation with polycyclic groups"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}"

PDEPEND="dev-gap/autpgrp
	dev-gap/Alnuth"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r *
}
