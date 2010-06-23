# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic

DESCRIPTION="Ratpoints tries to find all rational points on a hyperelliptic curve"
HOMEPAGE="http://www.mathe2.uni-bayreuth.de/stoll/programs/index.html"
SRC_URI="http://www.mathe2.uni-bayreuth.de/stoll/programs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc sse"

# TODO: test fails
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	append-cflags -DRATPOINTS_MAX_BITS_IN_PRIME=7 -fPIC

	use sse && append-cflags -DUSE_SSE

	emake CCFLAGS1="${CFLAGS}" || die
}

src_install() {
	dobin ratpoints || die
	dolib.a libratpoints.a || die
	insinto /usr/include
	doins ratpoints.h || die

	if use doc ; then
		dodoc ratpoints-doc.pdf || die
	fi
}

src_test() {
	emake CCFLAGS1="${CFLAGS}" test || die
}
