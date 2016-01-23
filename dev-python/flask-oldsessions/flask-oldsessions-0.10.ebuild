# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Compatibility layer for older flask-0.10 and under sessions"
HOMEPAGE="https://github.com/mitsuhiko/flask-oldsessions"
SRC_URI="https://github.com/mitsuhiko/flask-oldsessions/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
