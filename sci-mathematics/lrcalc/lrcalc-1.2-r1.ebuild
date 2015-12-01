# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="Littlewood-Richardson Calculator"
HOMEPAGE="http://www.math.rutgers.edu/~asbuch/lrcalc/"
SRC_URI="http://math.rutgers.edu/~asbuch/lrcalc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-1.2-includes.patch )

AUTOTOOLS_IN_SOURCE_BUILD=1
