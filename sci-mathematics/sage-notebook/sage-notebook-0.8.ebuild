# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON=2.6

inherit distutils eutils

MY_P="sagenb-${PV}.p1"

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="java"

RESTRICT="mirror"

# TODO: find out dependencies
DEPEND="~dev-python/pexpect-2.0
	>=dev-python/twisted-9.0
	>=dev-python/twisted-conch-9.0
	>=dev-python/twisted-lore-9.0
	>=dev-python/twisted-mail-9.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/twisted-words-9.0
	>=dev-python/jinja2-2.1.1
	>=net-zope/zope-testbrowser-3.7.0
	>=dev-python/docutils-0.5"
RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.6 )"

S="${WORKDIR}/${MY_P}/src/sagenb"

src_prepare() {
	# TODO: Report this to upstream
	epatch "${FILESDIR}/${PN}-0.7.5.1-fix-deprecated-module.patch"
	distutils_src_prepare

	if use java ; then
		mv sagenb/data/jmol/jmol sagenb/data/jmol/sage-jmol
		sed -i "s:jmol/jmol:jmol/sage-jmol:g" setup.py
	else
		epatch "${FILESDIR}/${P}-nojava.patch"
		rm -rf sagenb/data/jmol
		rm -rf sagenb/data/sage3d
	fi
}
