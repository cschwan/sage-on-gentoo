# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-r1 vcs-snapshot

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://pynac.sagemath.org/ https://bitbucket.org/burcin/pynac/overview"
SRC_URI="http://hg.pynac.org/pynac/get/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND="virtual/pkgconfig
	${PYTHON_DEPS}"
RDEPEND=""

AUTOTOOLS_AUTORECONF=yes

DOCS=( AUTHORS NEWS README )

myeconfargs=( PYTHON_VERSION="2.7" )
