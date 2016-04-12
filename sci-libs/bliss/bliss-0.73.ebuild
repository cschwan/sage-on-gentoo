# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

SRC_URI="http://www.tcs.hut.fi/Software/${PN}/${P}.zip"
DESCRIPTION="A Tool for Computing Automorphism Groups and Canonical Labelings of Graphs"
HOMEPAGE="http://www.tcs.hut.fi/Software/bliss/index.shtml"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gmp static-libs"

RDEPEND="gmp? ( dev-libs/gmp:0= )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-0.72-autotools.patch"
	"${FILESDIR}/${PN}-0.73-man.patch"
	)

src_prepare(){
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_with gmp) \
		$(use_enable static-libs static)
}

src_compile() {
	emake all $(usex doc html "")
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/html/. )

	default
}
