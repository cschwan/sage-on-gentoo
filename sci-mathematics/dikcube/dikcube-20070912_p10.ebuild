# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic versionator

MY_P="rubiks-$(replace_version_separator 1 '.')"

# TODO: Homepage ?
DESCRIPTION="Dik T. Winter's rubik's cube solver and related tools"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src/dik"

src_prepare() {
	# fixes a lot of QA warnings
	epatch "${FILESDIR}"/${P}-fix-missing-includes.patch
}

src_compile() {
	append-cflags -DLARGE_MEM -DVERBOSE

	emake CFLAGS="${CFLAGS}" all || die
}

src_install() {
	dobin dikcube size222 size333c sizesquare sizedom sizekoc1 sizekoc2 || die
	dodoc README || die
}
