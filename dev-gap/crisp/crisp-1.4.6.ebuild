# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computing with Radicals, Injectors, Schunck classes and Projectors"
HOMEPAGE="https://www.gap-system.org/Packages/crisp.html"
SLOT="0"
SRC_URI="https://github.com/bh11/${PN}/releases/download/${P^^}/${P}.tar.bz2"
RESTRICT=mirror

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0"

DOCS="README.txt"
HTML_DOCS=htm/*

GAP_PKG_OBJS="doc lib"
