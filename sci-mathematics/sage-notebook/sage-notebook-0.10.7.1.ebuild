# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
python_moduleroot="sagenb"
PYTHON_REQ_USE="ssl"

inherit distutils-r1 eutils user vcs-snapshot

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
HOMEPAGE="http://nb.sagemath.org"
SRC_URI="https://github.com/sagemath/sagenb/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+java server test"

RESTRICT="mirror test"

CDEPEND="~dev-python/pexpect-2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-12.3.0
	>=dev-python/twisted-mail-12.3.0
	>=dev-python/twisted-web-12.3.0
	!dev-python/twisted-web2
	>=dev-python/jinja-2.5.5[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.5[${PYTHON_USEDEP}]
	>=dev-python/flask-autoindex-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/flask-openid-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/flask-babel-0.8[${PYTHON_USEDEP}]
	dev-python/webassets[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( sci-mathematics/sage[testsuite,${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}
	sci-mathematics/sage[${PYTHON_USEDEP}]
	java? ( ~sci-chemistry/jmol-12.3.14
		~sci-chemistry/jmol-applet-12.3.14 )"

pkg_setup() {
	python_export python2_7 EPYTHON

	# create user to run the server
	if use server ; then
		enewgroup sage
		enewuser sage -1 /bin/bash /var/lib/sage sage
	fi
}

src_prepare() {
	# do not ship sage3d
	epatch "${FILESDIR}"/${PN}-0.10.7-setup.py.patch

	# remove sage3d
	rm -rf sagenb/data/sage3d || die "failed to remove sage3d"

	# find jmol
	sed -i "s:\"local\",\"share\",\"jmol\":\"share\",\"jmol-applet\":" \
		flask_version/base.py
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
