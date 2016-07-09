# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 autotools

DESCRIPTION="Expose the functionalities of Braiding as a shared library"
HOMEPAGE="https://github.com/miguelmarco/libbraiding"
EGIT_REPO_URI="git@github.com:miguelmarco/libbraiding.git"
EGIT_BRANCH=master

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	default

	eautoreconf
}
