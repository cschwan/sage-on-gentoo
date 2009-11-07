# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=0

inherit eutils

DESCRIPTION="genus2reduction is a program for computing the conductor and
reduction types for a genus 2 hyperelliptic curve"
HOMEPAGE="http://www.math.u-bordeaux.fr/~liu/G2R/"
SRC_URI="http://www.math.u-bordeaux.fr/~liu/G2R/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=sci-mathematics/pari-2.0"
RDEPEND="${DEPEND}"

src_compile() {
	epatch "${FILESDIR}/patch-provided-by-sage.patch"
	emake CC=gcc CFLAGS="${CFLAGS} -I/usr/include/pari" \
		LFLAGS="${LDFLAGS} -lpari -lm" \
		|| die "emake failed"
}

src_install() {
	exeinto /usr/bin
	doexe genus2reduction
	dodoc CHANGES README RELEASE.NOTES THANKS TODO
}
