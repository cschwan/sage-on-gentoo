# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

MY_PN="Flask-AutoIndex"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="A mod_autoindex for Flask"
HOMEPAGE="http://pythonhosted.org/Flask-AutoIndex"
SRC_URI="mirror://pypi/F/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
	dev-python/flask-silk[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
