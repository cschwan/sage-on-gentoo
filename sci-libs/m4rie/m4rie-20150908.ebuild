# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug openmp static-libs"

# TODO: tests do not compile since m4rie expects header already being installed
RESTRICT="mirror"

DEPEND=">=sci-libs/m4ri-20140914[openmp?]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-20150908-out_of_src_test.patch )

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare(){
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable openmp) \
		$(use_enable static-libs static)
}
