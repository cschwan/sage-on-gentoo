# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="http://forge.imag.fr/frs/download.php/119/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-3.1.1"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS ChangeLog )

PATCHES=( "${FILESDIR}"/${P}-fix-compiler-checks.patch )

src_prepare() {
	autotools-utils_src_prepare

	eautoreconf
}
