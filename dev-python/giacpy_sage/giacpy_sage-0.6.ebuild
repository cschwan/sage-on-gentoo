# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Cython frontend to the c++ library giac for sage"
HOMEPAGE="https://www.imj-prg.fr/~frederic.han/xcas/giacpy"
SRC_URI="http://webusers.imj-prg.fr/~frederic.han/xcas/giacpy/sage/giacpy-0.6.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-mathematics/giac-1.2.2.67
	>=sci-mathematics/sage-6.8
	>=dev-python/cython-0.24"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/giacpy-${PV}
