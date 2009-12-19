# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="gfan computes Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/gmp[-nocxx]
	sci-libs/cddlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/"

RESTRICT="mirror"

src_prepare () {
	sed -i "s/-O2/${CXXFLAGS}/" Makefile
}

# TODO: handle examples and documentation

src_compile() {
	emake || die "emake install failed"
	./gfan installlinks
}

src_install() {
	dobin gfan || die "emake install failed"

	# install symlink needed by sage
	for i in gfan_* ; do
		dosym gfan /usr/bin/$i || die "dosym failed"
	done
}
