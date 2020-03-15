# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="brial"
MY_P="${MY_PN}"-${PV}
DESCRIPTION="BriAL, a successor to PolyBoRI: Polynomials over Boolean Rings"
HOMEPAGE="https://github.com/BRiAl/BRiAl"

SRC_URI="https://github.com/BRiAl/BRiAl/releases/download/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND="!sci-mathematics/brial"
RDEPEND="${DEPEND}"
PDEPEND="sci-mathematics/sage"

S="${WORKDIR}"/${MY_P}/${PN}
