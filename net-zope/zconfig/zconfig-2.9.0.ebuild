# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zconfig/zconfig-2.9.0.ebuild,v 1.1 2011/03/25 01:33:30 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

MY_PN="ZConfig"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Structured Configuration Library"
HOMEPAGE="http://pypi.python.org/pypi/ZConfig"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="app-arch/unzip
	dev-python/setuptools
	test? ( net-zope/zope-testing )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="NEWS.txt README.txt"
PYTHON_MODNAME="${MY_PN}"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-2.7.1-fix_tests.patch"
}

src_install() {
	distutils_src_install

	# Don't install tests.
	rm -fr "${ED}"usr/$(get_libdir)/python*/site-packages/ZConfig/tests
}
