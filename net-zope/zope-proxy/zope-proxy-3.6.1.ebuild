# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-proxy/zope-proxy-3.6.1.ebuild,v 1.3 2010/12/05 18:58:11 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Generic Transparent Proxies"
HOMEPAGE="http://pypi.python.org/pypi/zope.proxy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zope-interface"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="CHANGES.txt README.txt"
PYTHON_MODNAME="${PN/-//}"
