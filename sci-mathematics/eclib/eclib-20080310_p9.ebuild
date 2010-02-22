# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=4.3.3
SAGE_PACKAGE=${PN}-20080310.p9

inherit eutils sage versionator

DESCRIPTION="Programs for enumerating and computing with elliptic curves defined
over the rational numbers."
# HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
# MY_P=${PN}-$(replace_version_separator 1 '.')
# SRC_URI="${SPKG_URI}/${MY_P}.spkg -> ${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/gmp
	>=sci-mathematics/pari-2.3.3
	>=dev-libs/ntl-5.4.2"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

# S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# patch for shared objects and various make issues.
	epatch "${FILESDIR}"/${PN}-makefiles.patch.bz2
}

src_compile() {
	emake PARI_PREFIX="/usr" NTL_PREFIX="/usr" || die "emake failed!"
	emake PARI_PREFIX="/usr" NTL_PREFIX="/usr" so \
		|| die "making shared libs failed!"
}

src_install() {
	dobin bin/* || die "installation of binaries failed"

	dolib.so lib/*.so* || die "installation of shared library failed"

	insinto /usr/include/eclib

	doins include/* || die "installation of headers failed"
}

src_test() {
	emake allcheck || die "tests failed"
}
