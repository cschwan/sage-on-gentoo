# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="A collection of useful macros to draw some classic graphs of the graph theory or others graphs"
HOMEPAGE="http://altermundus.com/pages/graphtheory.html"
SRC_URI="http://www.ctan.org/tex-archive/macros/latex/contrib/tkz/${PN}/latex/tkz-arith.sty
	http://www.ctan.org/tex-archive/macros/latex/contrib/tkz/${PN}/latex/${PN}.sty"

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
