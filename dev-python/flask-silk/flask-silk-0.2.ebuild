# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-Silk"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Adds silk icons to your Flask application or module, or extension"
HOMEPAGE="http://github.com/sublee/flask-silk"
SRC_URI="mirror://pypi/F/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RDEPEND="dev-python/flask"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
