# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/transaction/transaction-1.1.1.ebuild,v 1.1 2010/09/17 14:47:36 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Transaction management for Python"
HOMEPAGE="http://pypi.python.org/pypi/transaction"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zope-interface"
DEPEND="${RDEPEND}
	dev-python/setuptools"

DOCS="CHANGES.txt README.txt"

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/transaction/tests"
	}
	python_execute_function -q delete_tests
}
