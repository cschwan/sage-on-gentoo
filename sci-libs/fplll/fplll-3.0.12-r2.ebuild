# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils eutils

MY_P="lib${P}"

DESCRIPTION="fpLLL contains several algorithms on lattices"
HOMEPAGE="http://perso.ens-lyon.fr/damien.stehle/"
SRC_URI="http://perso.ens-lyon.fr/damien.stehle/downloads/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.0
	>=dev-libs/mpfr-2.3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS NEWS README )

src_prepare() {
	autotools-utils_src_prepare

	# Replace deprecated gmp functions which are removed with mpir-1.3.0
	sed -i "s:mpz_div_2exp:mpz_tdiv_q_2exp:g" src/nr.cpp src/util.h \
		|| die "failed to patch depracated gmp function calls"
}

src_configure() {
	# place headers into a subdirectory where it cannot conflict with others
	myeconfargs=( --includedir="${EPREFIX}"/usr/include/fplll )

	autotools-utils_src_configure
}
