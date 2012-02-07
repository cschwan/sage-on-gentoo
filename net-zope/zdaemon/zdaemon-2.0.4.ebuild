# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zdaemon/zdaemon-2.0.4.ebuild,v 1.5 2010/10/30 18:16:11 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Daemon process control library and tools for Unix-based systems"
HOMEPAGE="http://pypi.python.org/pypi/zdaemon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zconfig"
DEPEND="${RDEPEND}
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"

DOCS="CHANGES.txt README.txt"

src_install() {
	distutils_src_install

	# Don't install tests.
	rm -fr "${D}"usr/$(get_libdir)/python*/site-packages/zdaemon/tests
}
