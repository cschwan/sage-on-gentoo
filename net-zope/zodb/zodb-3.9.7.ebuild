# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zodb/zodb-3.9.7.ebuild,v 1.2 2010/11/29 02:15:49 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="ZODB3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Zope Object DataBase"
HOMEPAGE="http://pypi.python.org/pypi/ZODB3 https://launchpad.net/zodb"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="net-zope/transaction
	net-zope/zc-lockfile
	net-zope/zconfig
	net-zope/zdaemon
	net-zope/zope-event
	net-zope/zope-interface
	net-zope/zope-proxy
	!media-libs/FusionSound"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( net-zope/zope-testing )"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="doc/* HISTORY.txt README.txt"
PYTHON_MODNAME="BTrees persistent ZEO ZODB"

src_prepare() {
	distutils_src_prepare
	python_convert_shebangs -r 2 src
}

src_install() {
	distutils_src_install
	python_clean_installation_image
}
