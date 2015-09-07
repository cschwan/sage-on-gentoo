# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools-utils

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
# the label change with each realase check it before pushing a new ebuild
LABEL=250
SRC_URI="http://forge.imag.fr/frs/download.php/${LABEL}/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-4.0[cxx]"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS ChangeLog )
