# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

DESCRIPTION="GRaph Algorithms using PErmutation groups"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="bliss"

RDEPEND="sci-mathematics/gap:${SLOT}
	bliss? ( >=sci-libs/bliss-0.73 )
	!bliss? ( sci-mathematics/nauty )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.1-exec.patch
	)

DOCS="README"
HTML_DOCS=htm/*

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

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
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc grh lib
	doins *.g
}
