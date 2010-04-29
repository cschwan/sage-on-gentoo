# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils eutils

DESCRIPTION="Python module for spawning child applications and responding to expected patterns"
HOMEPAGE="http://pexpect.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/Release%20${PV}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RESTRICT="mirror"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-misc-bugs.patch
}

src_install() {
	distutils_src_install

	use doc && dohtml -r doc/* || die "dohtml failed"
}
