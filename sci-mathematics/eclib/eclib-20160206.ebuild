# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools vcs-snapshot

DESCRIPTION="enumerating and computing with elliptic curves defined over the rational numbers"
HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="https://github.com/JohnCremona/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="static-libs flint boost"

RESTRICT="mirror"

RDEPEND=">=sci-mathematics/pari-2.5.0:=
	>=dev-libs/ntl-5.4.2:=
	flint? ( sci-mathematics/flint:= )
	boost? ( dev-libs/boost[threads] )"
DEPEND="${RDEPEND}"

src_prepare(){
	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-allprogs \
		$(use_with flint) \
		$(use_with boost) \
		$(use_enable static-libs static)
}
