# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator autotools-utils

MY_PV="$(delete_version_separator 3 $(replace_version_separator 4 '.'))"

DESCRIPTION="Littlewood-Richardson Calculator"
HOMEPAGE="http://www.math.rutgers.edu/~asbuch/lrcalc/"
SRC_URI="http://sage.math.washington.edu/home/palmieri/SPKG/${PN}-${MY_PV}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

S="${WORKDIR}/${PN}-${MY_PV}"/src
