# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Jupyter kernel for PARI/GP"
HOMEPAGE="https://github.com/jdemeyer/pari_jupyter"
SRC_URI="https://github.com/jdemeyer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/ipykernel-4.0.0
	>=sci-mathematics/pari-2.8_pre20151001
	>=dev-python/cython-0.23.4"
RDEPEND="${DEPEND}"
