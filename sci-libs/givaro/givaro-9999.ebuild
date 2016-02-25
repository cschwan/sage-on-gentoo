# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 autotools

DESCRIPTION="Givaro is a C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
# the label change with each realase check it before pushing a new ebuild
EGIT_REPO_URI="git://github.com/linbox-team/givaro"
EGIT_BRANCH=master

LICENSE="CeCILL-B"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RESTRICT="mirror"

RDEPEND=">=dev-libs/gmp-4.0[cxx]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog )

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	econf \
		$(use_enable static-libs static)
}
