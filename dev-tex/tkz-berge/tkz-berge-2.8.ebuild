# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="tkz-berge is a collection of some useful macros if you want to draw some classic graphs of the graph theory or to make others graphs"
HOMEPAGE="http://altermundus.com/pages/graphtheory.html"
SRC_URI="http://altermundus.com/downloads/packages/tkz-arith.sty
	http://altermundus.com/downloads/packages/${PN}.sty"

# TODO: no license found

LICENSE="LPPL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# TODO: examples

RESTRICT="mirror"

# TODO: check dependencies

DEPEND=""
RDEPEND="dev-tex/pgf
	>=dev-tex/tkz-graph-2.7d"

# TODO: is there a more convenient way to do the following ?

src_unpack() {
	mkdir "${S}" || die "mkdir failed"

	for i in ${A} ; do
		cp "${DISTDIR}"/${i} "${S}" || die "cp failed"
	done
}
