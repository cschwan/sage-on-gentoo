# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=${PV}
SAGE_PACKAGE=sagenb-0.4.8

NEED_PYTHON=2.6

inherit distutils sage

DESCRIPTION="The Sage Notebook is a web-based graphical user interface for mathematical software"
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

# TODO: dependencies from makefile: python, pexpect, twisted, twisted-web,
# jinja, sphinx and docutils

# TODO: find out dependencies
DEPEND=">=dev-python/pexpect-2.0
	>=dev-python/twisted-8.2.0
	>=dev-python/twisted-conch-8.2.0
	>=dev-python/twisted-lore-8.2.0
	>=dev-python/twisted-mail-8.2.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/twisted-words-8.2.0
	>=dev-python/jinja-1.2
	>=dev-python/docutils-0.5"
RDEPEND="${DEPEND}"

# TODO: write a src_test function

src_prepare() {
	cat >> setup.cfg <<-EOF
		[install]
		prefix = ${SAGE_LOCAL}
	EOF

	# do not download Twisted - TODO: look for another way to solve this
	sed -i "s:twisted>=8.2::g" sagenb.egg-info/requires.txt \
		|| die "sed failed"
	sed -i "/install_requires = \['twisted>=8\.2'\],/d" setup.py \
		|| die "sed failed"

	distutils_src_prepare
}
