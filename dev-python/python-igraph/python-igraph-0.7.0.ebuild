# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface for the igraph library"
HOMEPAGE="http://igraph.org/python/"
SRC_URI="http://igraph.org/nightly/get/python/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/igraph
	virtual/pkgconfig"
RDEPEND="dev-libs/igraph"
