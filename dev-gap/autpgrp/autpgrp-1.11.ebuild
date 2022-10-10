# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computing the Automorphism Group of a p-Group"
HOMEPAGE="https://www.gap-system.org/Packages/autpgrp.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0"

DOCS="README CHANGES.md"
HTML_DOCS=htm/*

GAP_PKG_OBJS="doc gap"
