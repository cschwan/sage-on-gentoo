# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"
PYTHON_MODNAME="sagenb"

inherit distutils eutils

MY_P="sagenb-${PV}"
SAGE_DIR="sage-4.6.1.alpha2"

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
HOMEPAGE="http://www.sagemath.org"
#SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_DIR}/${SAGE_DIR}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="java"

RESTRICT="mirror"

DEPEND="~dev-python/pexpect-2.0
	>=dev-python/twisted-9.0
	>=dev-python/twisted-mail-9.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/jinja-2.1.1
	>=dev-python/docutils-0.5"
RDEPEND="${DEPEND}
	java? ( ~sci-chemistry/jmol-11.6.16
		~sci-chemistry/jmol-applet-11.6.16 )"

S="${WORKDIR}/${MY_P}/src/sagenb"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8-nojava.patch

	rm -rf sagenb/data/jmol || die "failed to remove jmol"

	sed -i \
		-e "s:jmolInitialize(\"/java/jmol\");jmolSetCallback(\"menuFile\",\"/java/jmol/appletweb/SageMenu.mnu\"):jmolInitialize(\"/java\",1):g" \
		-e "s:java/jmol/appletweb/Jmol.js:java/Jmol.js:g" \
		sagenb/data/sage/html/notebook/base.html || die "failed to patch for jmol"

	sed -i "s:java_path            = os.path.join(DATA):java_path            = os.path.join(\"${EPREFIX}/usr/share/jmol-applet\"):g" \
		sagenb/notebook/twist.py || die "failed to patch jmol path"

	# FIXME: sage3d isnot supposed to work out of the box.
	# It requires extra sun java components (dev-java/sun-java3d-bin)
	# The latest stable version of which is fetch restricted (but not latest unstable).
	# Furthermore the install procedure, as is, install a "binary" version of sage3d.
	# We would need to rebuild it from the provided sources.
	rm -rf sagenb/data/sage3d || die "failed sage3d"

	# change notebook path to prevent sage from writing to /opt/sage
	sed -i "s:load_notebook('notebook-test\.sagenb'):load_notebook(tmp_dir()+'.sagenb'):" \
		sagenb/notebook/twist.py || die "failed to change notebook path"

	# Ticket: #10131
	epatch "${FILESDIR}"/${PN}-0.8.2-add-pidfile-option.patch

	distutils_src_prepare
}
