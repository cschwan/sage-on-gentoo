# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="BriAL, a successor to PolyBoRI: Polynomials over Boolean Rings"
HOMEPAGE="https://github.com/BRiAl/pyBRiAl"

SRC_URI="https://github.com/BRiAl/pyBRiAl/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="doc static-libs"

RESTRICT="mirror"

DEPEND="!sci-mathematics/brial"
RDEPEND="${DEPEND}"
