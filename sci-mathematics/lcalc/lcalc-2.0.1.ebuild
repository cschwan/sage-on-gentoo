# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="A program for calculating with L-functions"
HOMEPAGE="https://gitlab.com/sagemath/lcalc/-/tree/master"
EGIT_REPO_URI="https://gitlab.com/sagemath/lcalc.git"
EGIT_COMMIT="9d9dbdb38f9c0d38e0a97392b70709fd3ce17552"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="pari"

# TODO: depend on pari[gmp] ?
DEPEND="dev-util/gengetopt
	pari? ( >=sci-mathematics/pari-2.13.0:= )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror"

src_prepare() {
	default

	eautoreconf
}

src_configure(){
	econf \
		$(use_with pari)
}
