# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator autotools-utils

MY_P="${PN}-$(replace_version_separator 1 '.')"

DESCRIPTION="Programs for enumerating and computing with elliptic curves defined over the rational numbers."
HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"

RESTRICT="mirror"

RDEPEND="dev-libs/gmp
	>=sci-mathematics/pari-2.5.0
	>=dev-libs/ntl-5.4.2"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}/src

src_prepare() {
	sed -i "s:/usr/local/bin/gp:${EPREFIX}/usr/bin/gp:" \
		libsrc/gpslave.cc || die "failed to set the right path for pari/gp"
}

src_configure() {
	local myeconfargs=(--disable-allprogs)

	autotools-utils_src_configure
}
