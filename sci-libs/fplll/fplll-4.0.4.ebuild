# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils

MY_P="lib${P}"

DESCRIPTION="fpLLL contains several algorithms on lattices"
HOMEPAGE="http://perso.ens-lyon.fr/damien.stehle/fplll"
SRC_URI="http://perso.ens-lyon.fr/damien.stehle/fplll/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.0
	>=dev-libs/mpfr-2.3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS NEWS README )
