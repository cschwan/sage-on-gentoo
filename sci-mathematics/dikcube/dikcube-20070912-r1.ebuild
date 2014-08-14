# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic

MY_P="rubiks-${PV}"

DESCRIPTION="Dik T. Winter's rubik's cube solver and related tools"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sageupstream/rubiks/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}/dik

src_prepare() {
	# fixes a lot of QA warnings
	epatch "${FILESDIR}"/${PN}-20070912_p10-fix-missing-includes.patch
	# Respect LDFLAGS
	epatch "${FILESDIR}"/${PN}-20070912_p10-fix-LDFLAGS.patch
}

src_compile() {
	append-cflags -DLARGE_MEM -DVERBOSE

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" all
}

src_install() {
	dobin dikcube size222 size333c sizesquare sizedom sizekoc1 sizekoc2
	dodoc README
}
