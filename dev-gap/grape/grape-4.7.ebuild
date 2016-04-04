# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit prefix versionator

MY_PV=$(replace_version_separator 1 'r' )
DESCRIPTION="GRaph Algorithms using PErmutation groups"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}${MY_PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bliss"

DEPEND=">=sci-mathematics/gap-4.7.8"
RDEPEND="${DEPEND}
	bliss? ( >=sci-libs/bliss-0.73 )
	!bliss? ( sci-mathematics/nauty )"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7-exec.patch
	)

src_prepare(){
	default

	local nauty="true"
	if use bliss ; then
		nauty="false"
	fi
	sed -i "s:@nauty@:$nauty:" lib/grape.g
	eprefixify lib/grape.g
}

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r doc grh htm lib tst
	doins *.g

	dodoc README
}
