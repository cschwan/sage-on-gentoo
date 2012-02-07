# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zc-lockfile/zc-lockfile-1.0.0.ebuild,v 1.6 2010/12/18 20:11:19 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
# DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="http://pypi.python.org/pypi/zc.lockfile"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose net-zope/zope-testing )"
RDEPEND=""

S="${WORKDIR}"/${MY_P}

PYTHON_MODNAME="${PN/-//}"
DOCS="doc.txt src/zc/lockfile/CHANGES.txt src/zc/lockfile/README.txt"

src_test() {
	testing() {
		# Future versions of net-zope/zope-testing will support Python 3.
		[[ "${PYTHON_ABI}" == 3.* ]] && return

		PYTHONPATH="build-${PYTHON_ABI}/lib" nosetests
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -f "${ED}"$(python_get_sitedir)/zc/lockfile/tests.py
	}
	python_execute_function -q delete_tests
}
