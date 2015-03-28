# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="This is an implementation of a modular decomposition algorithm."
HOMEPAGE="http://www.liafa.jussieu.fr/~fm/"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	$(tc-getCC) -o libmodulardecomposition.so dm.c random.c \
		-fPIC -shared -Wl,-soname=libmodulardecomposition.so
}

src_install(){
	dolib libmodulardecomposition.so
	cp dm_english.h modular_decomposition.h
	doheader modular_decomposition.h
}
