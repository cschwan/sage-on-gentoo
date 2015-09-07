# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} pypy{1_8,1_9} )

inherit distutils-r1 eutils

DESCRIPTION="Python module for spawning child applications and responding to expected patterns"
HOMEPAGE="http://pexpect.sourceforge.net/"
MY_PN=pexpect
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/project/${MY_PN}/${MY_PN}/Release%20${PV}/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${MY_P}-fix-misc-bugs.patch
	"${FILESDIR}"/${MY_P}-env.patch
	"${FILESDIR}"/sage-pexpect-setup.patch
	)

python_prepare(){
	mv pexpect.py sage_pexpect.py
}
