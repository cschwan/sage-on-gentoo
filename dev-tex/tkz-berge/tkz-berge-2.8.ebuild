# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://altermundus.com/pages/graphtheory.html"
SRC_URI="http://altermundus.com/downloads/packages/tkz-arith.sty
	http://altermundus.com/downloads/packages/${PN}.sty"

# TODO: no license found

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: examples

RESTRICT="mirror"

# TODO: check dependencies

DEPEND=">=dev-tex/tkz-graph-2.7d"
RDEPEND="${DEPEND}"

# TODO: is there a more convenient way to do the following ?

src_unpack() {
	mkdir "${S}" || die "mkdir failed"

	for i in ${A} ; do
		cp "${DISTDIR}"/${i} "${S}" || die "cp failed"
	done
}
