# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Python module for spawning child applications and responding to expected patterns"
HOMEPAGE="http://pexpect.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/Release%20${PV}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-misc-bugs.patch
}
