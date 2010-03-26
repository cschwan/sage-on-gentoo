# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

DESCRIPTION="C implementation of the Double Description Method of Motzkin et al."
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND=">=dev-libs/gmp-4.2.2"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

# TODO: examples, mathematica interface ...

src_prepare() {
	epatch "${FILESDIR}/${P}-libtool.patch"
	# add cdd_both_reps binary
	epatch "${FILESDIR}/cdd_both_reps-make.patch"
	cp "${FILESDIR}/cdd_both_reps.c" "${S}/src/"
	ln -s "${S}/src/cdd_both_reps.c" "${S}/src-gmp/cdd_both_reps.c"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc ChangeLog README || die "dodoc failed"

	# install manuals
	if use doc ; then
		dodoc doc/cddlibman.pdf doc/cddlibman.ps || die "dodoc failed"
	fi
}
