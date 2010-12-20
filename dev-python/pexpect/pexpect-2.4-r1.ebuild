# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-2.4.ebuild,v 1.8 2009/12/30 00:56:21 arfrever Exp $

EAPI="3"

PYTHON_MODNAME="ANSI.py fdpexpect.py FSM.py pexpect.py pxssh.py screen.py"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils

DESCRIPTION="Python module for spawning child applications and responding to expected patterns"
HOMEPAGE="http://pexpect.sourceforge.net/ http://pypi.python.org/pypi/pexpect"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

src_prepare(){
	epatch "${FILESDIR}"/${PN}.py-isdir_bug_fix.patch
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml -r doc/* || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
