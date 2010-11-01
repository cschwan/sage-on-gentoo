# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils versionator

MY_P="${PN}-$(replace_version_separator 1 '.')"

DESCRIPTION="Programs for enumerating and computing with elliptic curves defined over the rational numbers."
HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

RDEPEND="dev-libs/gmp
	>=sci-mathematics/pari-2.3.3:0
	>=dev-libs/ntl-5.4.2"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# patch for shared objects and various make issues.
	epatch "${FILESDIR}"/${P}-makefiles.patch.bz2

	sed -i "s:/usr/local/bin/gp:${EPREFIX}/usr/bin/gp:" \
		procs/gpslave.cc || die "failed to set the right path for pari/gp"
}

src_compile() {
	emake all so || die
}

src_install() {
	dobin bin/* || die
	dolib.so lib/*.so* || die
	insinto /usr/include/eclib
	doins include/* || die
}

src_test() {
	emake allcheck || die
}
