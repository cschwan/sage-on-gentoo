# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="enumerating and computing with elliptic curves defined over the rational numbers"
HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="http://homepages.warwick.ac.uk/staff/J.E.Cremona/ftp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs flint"

RESTRICT="mirror"

RDEPEND=">=sci-mathematics/pari-2.5.0:=
	>=dev-libs/ntl-5.4.2:=
	flint? ( sci-mathematics/flint:= )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-allprogs \
		--without-boost \
		$(use_with flint) \
		$(use_enable static-libs static)
}

src_install(){
	default
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
