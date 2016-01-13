# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils python-r1 vcs-snapshot eutils

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://pynac.sagemath.org/ https://github.com/pynac/pynac"
SRC_URI="https://github.com/pynac/pynac/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND="dev-libs/gmp:0=
	virtual/pkgconfig
	${PYTHON_DEPS}"
RDEPEND="dev-libs/gmp:0=
	${PYTHON_DEPS}"

DOCS=( AUTHORS NEWS README )

pkg_setup(){
	python_setup
}
