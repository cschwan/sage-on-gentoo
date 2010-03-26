# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit eutils

DESCRIPTION="Ratpoints tries to find all rational points on a hyperelliptic
curve"
HOMEPAGE="http://www.mathe2.uni-bayreuth.de/stoll/programs/index.html"
SRC_URI="http://www.mathe2.uni-bayreuth.de/stoll/programs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake CCFLAGS1="${CFLAGS} -fPIC" || die "emake failed"
}

src_install() {
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/include"
	mkdir -p "${D}/usr/lib"

	emake INSTALL_DIR="${D}/usr" install || die "emake install failed"

	dodoc ratpoints-doc.pdf
}
