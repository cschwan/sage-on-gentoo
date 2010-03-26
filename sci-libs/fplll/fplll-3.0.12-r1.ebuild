# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

MY_P="lib${P}"

DESCRIPTION="fpLLL contains several algorithms on lattices"
HOMEPAGE="http://perso.ens-lyon.fr/damien.stehle/"
SRC_URI="http://perso.ens-lyon.fr/damien.stehle/downloads/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.0
	>=dev-libs/mpfr-2.3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Replace deprecated functions which are removed with mpir-1.3.0
	sed -i "s:mpz_div_2exp:mpz_tdiv_q_2exp:g" src/nr.cpp src/util.h
}

src_configure() {
	# place headers into a subdirectory where it cannot conflict with others
	econf \
		--includedir=/usr/include/fplll \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README || die "dodoc failed"
}
