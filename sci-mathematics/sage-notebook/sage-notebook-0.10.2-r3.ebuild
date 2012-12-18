# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
python_moduleroot="sagenb"
PYTHON_REQ_USE="ssl"

inherit distutils-r1 eutils user vcs-snapshot

MY_PN="sagemath-sagenb"

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
HOMEPAGE="http://nb.sagemath.org"
SRC_URI="https://github.com/sagemath/sagenb/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+java server test"

RESTRICT="mirror test"

CDEPEND="~dev-python/pexpect-2.0
	>=dev-python/twisted-12.0
	>=dev-python/twisted-mail-12.0
	>=dev-python/twisted-web-12.0
	!dev-python/twisted-web2
	>=dev-python/jinja-2.5.5
	>=dev-python/docutils-0.5
	>=dev-python/flask-autoindex-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/flask-openid-1.0.1
	>=dev-python/flask-babel-0.8
	dev-python/webassets[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( sci-mathematics/sage[testsuite,${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}
	sci-mathematics/sage[${PYTHON_USEDEP}]
	java? ( ~sci-chemistry/jmol-12.3.14
		~sci-chemistry/jmol-applet-12.3.14 )"

pkg_setup() {
	python_export python2_7 EPYTHON

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
	sed -i "s:import base:import flask_version.base:" \
		sagenb/notebook/run_notebook.py \
		|| die "failed to patch for flask_version path"

	# remove sage3d
	rm -rf sagenb/data/sage3d || die "failed to remove sage3d"

	# find jmol and various openid
	epatch "${FILESDIR}"/${PN}-0.9.1-base.patch
	sed -i "s:jmol/appletweb/Jmol.js:jmol/Jmol.js:g" \
		sagenb/data/sage/html/notebook/base.html

	# fix SAGE_ROOT
	epatch "${FILESDIR}"/${PN}-0.9.1-notebook.patch

	mkdir conf.d || die "failed to create directory"
	mkdir init.d || die "failed to create directory"

	cp "${FILESDIR}"/${PN}-0.10.2 init.d/${PN} || die "failed to copy file"
	cp "${FILESDIR}"/${PN}.conf-0.10.2 conf.d/${PN} || die "failed to copy file"

	# correct the location of JmolHelp.html if include in jmol-applet[sage]
# 	sed -i "s:\/java\/jmol\/appletweb:\/java\/jmol:g" \
# 		sagenb/data/sage/js/jmol_lib.js

	distutils-r1_src_prepare
}

src_install() {
	# install runscript+configuration file to run the notebook as a daemon
	if use server ; then
		doinitd init.d/${PN}
		doconfd conf.d/${PN}
	fi

	distutils-r1_src_install
}
