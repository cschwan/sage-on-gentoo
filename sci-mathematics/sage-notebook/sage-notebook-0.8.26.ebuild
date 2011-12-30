# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.7"
PYTHON_MODNAME="sagenb"

inherit distutils eutils user

MY_P="sagenb-${PV}"
SAGE_P="sage-4.8.alpha5"

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+java server ssl"

RESTRICT="mirror"

CDEPEND="~dev-python/pexpect-2.0
	>=dev-python/twisted-9.0
	>=dev-python/twisted-mail-9.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/jinja-2.5.5
	>=dev-python/docutils-0.5"
DEPEND="${CDEPEND}
	test? ( sci-mathematics/sage[testsuite] )"
RDEPEND="${CDEPEND}
	sci-mathematics/sage
	java? ( >=sci-chemistry/jmol-12.0.45
		>=sci-chemistry/jmol-applet-12.0.45 )
	ssl? ( net-libs/gnutls )"

S="${WORKDIR}/${MY_P}/src/sagenb"

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
	# patch for latest jmol-12.0.45 trac 9238
	epatch "${FILESDIR}"/trac_9238_interactive_js.patch

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

	# revised 0.8.14+
	epatch "${FILESDIR}"/${PN}-0.8.16-twistd-python-version.patch

	# https://github.com/cschwan/sage-on-gentoo/issues/63
	epatch "${FILESDIR}"/${PN}-0.8.14-fix-secure-connection.patch

	mkdir conf.d || die "failed to create directory"
	mkdir init.d || die "failed to create directory"

	cp "${FILESDIR}"/${PN} init.d/${PN} || die "failed to copy file"
	cp "${FILESDIR}"/${PN}.conf conf.d/${PN} || die "failed to copy file"

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
