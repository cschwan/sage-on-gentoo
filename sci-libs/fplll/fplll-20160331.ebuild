# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Different implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/dstehle/fplll"
EGIT_REPO_URI="http://github.com/dstehle/fplll.git"
EGIT_BRANCH=master
EGIT_COMMIT=b50fd91ba0aeea2067dc9d82e6c352dbe0210eb3

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.2.0:0
	>=dev-libs/mpfr-2.3.0:0"
RDEPEND="${DEPEND}"

src_prepare(){
	default

	./autogen.sh
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS NEWS" default
}
