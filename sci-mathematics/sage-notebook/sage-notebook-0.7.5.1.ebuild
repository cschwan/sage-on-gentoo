# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SAGE_VERSION=4.3.3
SAGE_PACKAGE=sagenb-${PV}

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

S="${WORKDIR}/${SAGE_PACKAGE}/src/sagenb"

# TODO: write a src_test function
