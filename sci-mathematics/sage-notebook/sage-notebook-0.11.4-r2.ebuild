# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

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

CDEPEND="~dev-python/sage-pexpect-2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-mail-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-14.0.0[${PYTHON_USEDEP}]
	!dev-python/twisted-web2
	>=dev-python/jinja-2.5.5[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.5[${PYTHON_USEDEP}]
	>=dev-python/flask-autoindex-0.5[${PYTHON_USEDEP}]
	>=dev-python/flask-openid-1.2.3[${PYTHON_USEDEP}]
	dev-python/flask-oldsessions[${PYTHON_USEDEP}]
	<dev-python/flask-babel-0.9[${PYTHON_USEDEP}]
	dev-python/webassets[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( sci-mathematics/sage[testsuite,${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}
	sci-mathematics/sage[${PYTHON_USEDEP}]
	dev-libs/mathjax
	java? ( >=sci-chemistry/sage-jmol-bin-14.2.11 )"

pkg_setup() {
	python_export python2_7 EPYTHON PYTHON PYTHON_SITEDIR

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

	# use system mathjax
	rm -rf sagenb/data/mathjax || die "failed to remove mathjax"

	# correct path for jmol
	epatch "${FILESDIR}"/${PN}-0.11.2-base.patch

	# fix SAGE_ROOT
	epatch "${FILESDIR}"/${PN}-0.9.1-notebook.patch

	# in sage 6.6+ we get rid of the output subfolder for the documentation
	if has_version ">=sci-mathematics/sage-6.6" ; then
		sed -i "s:SAGE_DOC, 'output':SAGE_DOC:g" \
			sagenb/flask_version/doc.py \
			sagenb/flask_version/base.py
	fi

	mkdir conf.d || die "failed to create directory"
	mkdir init.d || die "failed to create directory"

	cp "${FILESDIR}"/${PN}-0.10.2 init.d/${PN} || die "failed to copy file"
	cp "${FILESDIR}"/${PN}.conf-0.10.2 conf.d/${PN} || die "failed to copy file"

	# migrate to sage-pexpect
	epatch "${FILESDIR}"/${PN}-pexpect.patch
	sed -i "s:import pexpect:import sage_pexpect as pexpect:g" \
		`grep -rl "import pexpect" *`

	distutils-r1_src_prepare
}

python_install_all() {
	# install runscript+configuration file to run the notebook as a daemon
	if use server ; then
		doinitd init.d/${PN}
		doconfd conf.d/${PN}
		dodir /var/lib/sage/.matplotlib
		insinto /var/lib/sage/.matplotlib
		doins "${FILESDIR}"/matplotlibrc
	fi

	distutils-r1_python_install_all

	# link in system mathjax
	ln -snf "${EPREFIX}"/usr/share/mathjax \
		"${D}$(python_get_sitedir)"/sagenb/data/mathjax || die
}

pkg_preinst() {
	# remove old mathjax folder if present
	[[ -d "${ROOT}$(python_get_sitedir)/sagenb/data/mathjax" ]] \
		&& rm -rf "${ROOT}$(python_get_sitedir)/sagenb/data/mathjax"
}

pkg_postinst() {
	einfo "If you experience the following error when starting a SSL secured notebook:"
	einfo "  'You must install certtool to use the secure notebook server.'"
	einfo "install net-libs/gnutls."
}
