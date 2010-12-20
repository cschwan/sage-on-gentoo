# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="tkz-graph is a set of convenient macros for drawing graphs"
HOMEPAGE="http://altermundus.com/pages/graph.html"
SRC_URI="http://altermundus.com/downloads/packages/${PN}.sty"

# TODO: could not find a license

LICENSE="LPPL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# TODO: examples

RESTRICT="mirror"

# TODO: check dependencies

DEPEND=""
RDEPEND="dev-tex/pgf"

# TODO: is there a more convenient way to do the following ?

src_unpack() {
	mkdir "${S}" || die "mkdir failed"
	cp "${DISTDIR}"/${A} "${S}" || die "cp failed"
}
