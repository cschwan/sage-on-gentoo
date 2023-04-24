# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="A Meta Package for GAP Documentation"
HOMEPAGE="https://www.gap-system.org/Packages/gapdoc.html"
SLOT="0"
SRC_URI="https://github.com/frankluebeck/${PN}/archive/relv${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=sci-mathematics/gap-4.12.0"

DOCS="CHANGES README.md"

S="${WORKDIR}"/${PN}-relv${PV}

GAP_PKG_OBJS="3k+1 doc example lib styles *.dtd version"
