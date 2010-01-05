# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

SAGE_VERSION=4.3
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

DEPEND=""
RDEPEND="${DEPEND}"

# TODO: write a src_test function
