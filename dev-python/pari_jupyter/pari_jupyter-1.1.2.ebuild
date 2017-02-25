# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Jupyter kernel for PARI/GP"
HOMEPAGE="https://github.com/jdemeyer/pari_jupyter"
SRC_URI="https://github.com/jdemeyer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/ipykernel-4.0.0[${PYTHON_USEDEP}]
	>=sci-mathematics/pari-2.8_pre20160209
	>=dev-python/cython-0.23.4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
