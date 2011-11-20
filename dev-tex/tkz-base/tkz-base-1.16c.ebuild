# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="tkz-base is a base package to give easy access to programation with tikz"
HOMEPAGE="http://altermundus.com"
BASESRC="http://mirror.ctan.org/macros/latex/contrib/tkz/${PN}/latex/tkz/tkzbase"
SRC_URI="${BASESRC}/tkz-base.cfg
	${BASESRC}/tkz-base.sty
	${BASESRC}/tkz-obj-marks.tex
	${BASESRC}/tkz-obj-points.tex
	${BASESRC}/tkz-obj-segments.tex
	${BASESRC}/tkz-tools-arith.tex
	${BASESRC}/tkz-tools-base.tex
	${BASESRC}/tkz-tools-math.tex
	${BASESRC}/tkz-tools-misc.tex
	${BASESRC}/tkz-tools-obsolete.tex
	${BASESRC}/tkz-tools-utilities.tex"

LICENSE="LPPL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="dev-tex/pgf"

src_unpack() {
	mkdir "${S}" || die "mkdir failed"

	for i in ${A} ; do
		cp "${DISTDIR}"/${i} "${S}" || die "cp failed"
	done
}

src_install() {
	latex-package_src_install
	insinto /usr/share/texmf/tex/latex/tkz-base
	doins *.tex
}
