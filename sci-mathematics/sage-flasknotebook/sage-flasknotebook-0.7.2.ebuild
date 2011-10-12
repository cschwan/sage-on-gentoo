# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7"
PYTHON_MODNAME="sagenb flask_version"

inherit distutils eutils mercurial python

DESCRIPTION="The Sage Notebook graphical user interface using Flask"
HOMEPAGE="http://www.sagemath.org"
#EHG_REPO_URI="http://rkirov-flask.googlecode.com/hg/"
EHG_REPO_URI="http://gutow-flask.googlecode.com/hg/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+java ssl"

RESTRICT="mirror"

DEPEND=">=dev-python/twisted-9.0
	>=dev-python/twisted-mail-9.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/jinja-2.5.5
	>=dev-python/docutils-0.5
	>=dev-python/flask-autoindex-0.3.0
	>=dev-python/flask-openid-1.0.1
	>=dev-python/flask-babel-0.7
	>=dev-python/Babel-0.9.6"
RDEPEND="${DEPEND}
	!sci-mathematics/sage-notebook
	java? ( >=sci-chemistry/jmol-12.0.45
		>=sci-chemistry/jmol-applet-12.0.45 )
	ssl? ( net-libs/gnutls )"

pkg_setup() {
	# Sage now will only work with python 2.7.*
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	# patch for latest jmol-12.0.45 trac 9238 (the following appears to be present)
#	epatch "${FILESDIR}"/trac_9238_interactive_js.patch
#	epatch "${FILESDIR}"/trac_9238_jmol_lib_async.patch

	# patch for path fix in flask (the following is already present)
#	epatch "${FILESDIR}"/trac_11503_path_fix.patch 
	sed -i \
		-e "s:self.add_static_path('/java', DATA):self.add_static_path('/java', '${EPREFIX}/usr/share/jmol-applet'):g" \
		-e "s:os.path.join(os.environ\[\"SAGE_ROOT\"],\"local\",\"share\",\"jmol\")):os.path.join(os.environ\[\"SAGE_LOCAL\"],\"share\",\"jmol\")):g" \
		flask_version/base.py || die "failed to fix path in flask"

	epatch "${FILESDIR}"/${PN}-nosage3d.patch

#	rm -rf sagenb/data/jmol || die "failed to remove jmol"

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

	# https://github.com/cschwan/sage-on-gentoo/issues/63
	epatch "${FILESDIR}"/${PN}-fix-secure-connection.patch

	distutils_src_prepare
}
