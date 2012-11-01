# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.7"
PYTHON_MODNAME="sagenb"
PYTHON_USE_WITH_OPT="ssl"

inherit distutils eutils user

MY_PN="sagemath-sagenb"

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
HOMEPAGE="http://nb.sagemath.org"
SRC_URI="https://github.com/sagemath/sagenb/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+java server ssl"

RESTRICT="mirror"

CDEPEND="~dev-python/pexpect-2.0
	>=dev-python/twisted-12.0
	>=dev-python/twisted-mail-12.0
	>=dev-python/twisted-web-12.0
	!dev-python/twisted-web2
	>=dev-python/jinja-2.5.5
	>=dev-python/docutils-0.5
	>=dev-python/flask-autoindex-0.4.1
	>=dev-python/flask-openid-1.0.1
	>=dev-python/flask-babel-0.8
	dev-python/webassets"
DEPEND="${CDEPEND}
	test? ( sci-mathematics/sage[testsuite] )"
RDEPEND="${CDEPEND}
	sci-mathematics/sage
	java? ( ~sci-chemistry/jmol-12.3.27
		~sci-chemistry/jmol-applet-12.3.27 )"

# github release tag
TAG=dbabb90
S="${WORKDIR}/${MY_PN}-${TAG}"

pkg_setup() {
	# Sage now will only works with python 2.7.*
	python_set_active_version 2.7
	python_pkg_setup
	export DOT_SAGE="${S}"

	# create user to run the server
	if use server ; then
		enewgroup sage
		enewuser sage -1 /bin/bash /var/lib/sage sage
	fi
}

src_prepare() {
	# ship flask_version and not sage3d
	epatch "${FILESDIR}"/${PN}-0.10.2-setup.py.patch

	# find flask_version in the right place
	sed -i "s:import base:import flask_version.base:" sagenb/notebook/run_notebook.py || die "failed to patch for flask_version path"

	# remove sage3d
	rm -rf sagenb/data/sage3d || die "failed to remove sage3d"

	# find jmol
	epatch "${FILESDIR}"/${PN}-0.9.1-base-jmol.patch
	sed -i "s:jmol/appletweb/Jmol.js:jmol/Jmol.js:g" sagenb/data/sage/html/notebook/base.html

	# fix SAGE_ROOT
	epatch "${FILESDIR}"/${PN}-0.9.1-notebook.patch

	mkdir conf.d || die "failed to create directory"
	mkdir init.d || die "failed to create directory"

	cp "${FILESDIR}"/${PN} init.d/${PN} || die "failed to copy file"
	cp "${FILESDIR}"/${PN}.conf conf.d/${PN} || die "failed to copy file"

	# correct the location of JmolHelp.html if include in jmol-applet[sage]
#	sed -i s:\/java\/jmol\/appletweb:\/java\/jmol:g sagenb/data/sage/js/jmol_lib.js

	distutils_src_prepare
}

src_install() {
	# install runscript+configuration file to run the notebook as a daemon
	if use server ; then
		doinitd init.d/${PN}
		doconfd conf.d/${PN}
	fi

	distutils_src_install
}

src_test() {
	PYTHONPATH="." default_src_test
}
