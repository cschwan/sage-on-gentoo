# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7:2.7"

inherit autotools-utils python

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://pynac.sagemath.org/ https://bitbucket.org/burcin/pynac/overview"
SRC_URI="https://bitbucket.org/burcin/pynac/get/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND="dev-util/pkgconfig"
RDEPEND=""

S="${WORKDIR}/burcin-pynac-1ad314a6d88e"

DOCS=( AUTHORS NEWS README )

pkg_setup() {
	# This version will use python-2.7
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	eautoreconf
}
