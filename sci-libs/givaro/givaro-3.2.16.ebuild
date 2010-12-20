# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/Downloads/${P}.tar.gz"

LICENSE="CeCILL-B GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-3.1.1"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS ChangeLog )
