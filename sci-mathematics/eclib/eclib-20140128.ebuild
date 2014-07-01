# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator autotools-utils

DESCRIPTION="Programs for enumerating and computing with elliptic curves defined over the rational numbers."
HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="static-libs flint boost"

RESTRICT="mirror"

RDEPEND=">=sci-mathematics/pari-2.5.0
	>=dev-libs/ntl-5.4.2
	flint? ( >=sci-mathematics/flint-2.3 )
	boost? ( dev-libs/boost[threads] )"
DEPEND="${RDEPEND}"

src_prepare() {
	# https://github.com/JohnCremona/eclib/issues/3
	# patch pushed upstream for consideration
	epatch "${FILESDIR}"/${P}-configure.patch
	# https://github.com/JohnCremona/eclib/issues/4
	epatch "${FILESDIR}"/${P}-gp.patch
	mv libsrc/gpslave.cc libsrc/gpslave.cc.in

	eautomake
	autoreconf
}

src_configure() {
	local myeconfargs=(--disable-allprogs
		$(use_with flint)
		$(use_with boost)
		)

	autotools-utils_src_configure
}
