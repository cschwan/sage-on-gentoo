# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="https://github.com/linbox-team/givaro/releases/download/v${PV}/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-4.0[cxx]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog )

src_configure(){
	econf \
		$(use_enable static-libs static)
}
