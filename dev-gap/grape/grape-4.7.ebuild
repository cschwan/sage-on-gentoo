# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

MY_PV=$(ver_rs 1 'r' )
DESCRIPTION="GRaph Algorithms using PErmutation groups"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.8.6
SRC_URI="https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p6_2016_11_12-14_25.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE="bliss"

RDEPEND="sci-mathematics/gap:${SLOT}
	bliss? ( >=sci-libs/bliss-0.73 )
	!bliss? ( sci-mathematics/nauty )"

S="${WORKDIR}/gap4r8/pkg/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7-exec.patch
	)

src_prepare(){
	default

	rm -f configure \
		Makefile \
		Makefile.in

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
