# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
SUPPORT_PYTHON_ABIS=1
MY_PACKAGE="Web2"

inherit eutils twisted versionator

DESCRIPTION="Experimental Twisted web2 server, programmable in Python"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-python/twisted"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

PYTHON_MODNAME="twisted/plugins twisted/web2"
