# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7:2.7"

inherit autotools-utils python

SAGE_P="sage-4.6"

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="http://pynac.sagemath.org/"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND="dev-util/pkgconfig"
RDEPEND=""

S="${WORKDIR}/${P}/src"

DOCS=( AUTHORS NEWS README )

pkg_setup() {
	# This version will use python-2.7
	python_set_active_version 2.7
	python_pkg_setup
}
