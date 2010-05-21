# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils sage versionator

MY_P="${PN}-$(replace_version_separator 1 '.')"

DESCRIPTION="Programs for enumerating and computing with elliptic curves defined over the rational numbers."
HOMEPAGE="http://www.sagemath.org http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/gmp
	>=sci-mathematics/pari-2.3.3
	>=dev-libs/ntl-5.4.2"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# patch for shared objects and various make issues.
	epatch "${FILESDIR}"/${P}-makefiles.patch.bz2
}

src_compile() {
	emake all so || die "emake failed"
}

src_install() {
	dobin bin/* || die "dobin failed"
	dolib.so lib/*.so* || die "dolib.so failed"
	insinto /usr/include/eclib
	doins include/* || die "doins failed"
}

src_test() {
	emake allcheck || die "emake failed"
}
