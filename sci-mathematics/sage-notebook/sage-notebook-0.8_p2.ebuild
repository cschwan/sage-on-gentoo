# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON=2.6

inherit distutils eutils versionator

MY_P="sagenb-$(replace_version_separator 2 '.')"

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
	>=dev-python/jinja-2.1.1
	>=dev-python/docutils-0.5"
RDEPEND="${DEPEND}
	java? ( ~sci-chemistry/jmol-11.6.16[vhosts] )"

S="${WORKDIR}/${MY_P}/src/sagenb"

src_prepare() {
	# Ticket #9148:
	# replace deprecated sha module with haslib to prevent warnings
	epatch "${FILESDIR}"/${PN}-0.7.5.1-fix-deprecated-module.patch

	epatch "${FILESDIR}"/${PN}-0.8-nojava.patch
#	rm -rf sagenb/data/jmol/*.jar || die "rm failed"
#	rm -rf sagenb/data/jmol/jars || die "rm failed"
#	rm sagenb/data/jmol/jmol sagenb/data/jmol/jmol.sh || die "rm failed"
	rm -rf sagenb/data/jmol
	sed -i \
		-e "s:jmolInitialize(\"/java/jmol\");jmolSetCallback(\"menuFile\",\"/java/jmol/appletweb/SageMenu.mnu\"):jmolInitialize(\"/java\",1):g" \
		-e "s:java/jmol/appletweb/Jmol.js:java/Jmol.js:g" \
		sagenb/data/sage/html/notebook/base.html
	sed -i "s:java_path            = os.path.join(DATA):java_path            = os.path.join(\"/usr/share/webapps/jmol/11.6.16/htdocs\"):g" \
		sagenb/notebook/twist.py

	# FIXME: sage3d isnot supposed to work out of the box.
	# It requires extra sun java components (dev-java/sun-java3d-bin)
	# The latest stable version of which is fetch restricted (but not latest unstable).
	# Furthermore the install procedure, as is, install a "binary" version of sage3d.
	# We would need to rebuild it from the provided sources.
	rm -rf sagenb/data/sage3d || die "rm failed"

	distutils_src_prepare
}