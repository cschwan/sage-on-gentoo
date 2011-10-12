# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"
PYTHON_MODNAME="sagenb flask_version"

inherit distutils eutils mercurial python

DESCRIPTION="The Sage Notebook graphical user interface using Flask"
HOMEPAGE="http://www.sagemath.org"
EHG_REPO_URI="http://rkirov-flask.googlecode.com/hg/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="java"

RESTRICT="mirror"

DEPEND=">=dev-python/twisted-9.0
	>=dev-python/twisted-mail-9.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/jinja-2.5.5
	>=dev-python/docutils-0.5
	>=dev-python/flask-autoindex-0.3.0
	>=dev-python/flask-openid-1.0.1"
RDEPEND="${DEPEND}
	!sci-mathematics/sage-notebook
	java? ( ~sci-chemistry/jmol-11.6.16
		~sci-chemistry/jmol-applet-11.6.16 )"

pkg_setup() {
	# Sage only works with python 2.6.*
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8-nojava.patch

	rm -rf sagenb/data/jmol || die "failed to remove jmol"

	epatch "${FILESDIR}"/${PN}-setup.py.patch

	sed -i \
		"s:os.path.join(os.environ\['SAGE_ROOT'\], 'devel', 'sagenb', 'flask_version'):os.path.join('${EPREFIX}$(python_get_sitedir)', 'flask_version'):g" \
		sagenb/notebook/run_notebook.py || die "failed to patch for flask_version path"

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

	distutils_src_prepare
}
