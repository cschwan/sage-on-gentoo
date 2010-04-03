# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils eutils sage versionator

MY_PV="$(replace_version_separator 3 '.')"
MY_P="moin-${MY_PV}"
PYTHON_MODNAME="sage-MoinMoin"
DESCRIPTION="Sage's version of Python WikiClone"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=dev-lang/python-2.3"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}/src/moin"

src_prepare() {
	# Applying Sage supplied patches.
	cd ../..
	cp patches/wikiconfig.py   src/moin/wiki/config/wikiconfig.py
	cp patches/mointwisted.py  src/moin/wiki/server/
	cp -r patches/action       src/moin/wiki/data/plugin/
	cp -r patches/macro        src/moin/wiki/data/plugin/
	cp -r patches/parser       src/moin/wiki/data/plugin/
	cp patches/load.js         src/jsmath/easy/load.js
	cp -r src/jsmath           src/moin/MoinMoin/web/static/htdocs/common/js

	cd "${S}"
	cat >> setup.cfg <<-EOF
	[install]
	prefix = ${SAGE_LOCAL}
	EOF
	distutils_src_prepare
}
