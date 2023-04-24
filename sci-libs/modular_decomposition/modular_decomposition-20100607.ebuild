# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs multilib

DESCRIPTION="This is an implementation of a modular decomposition algorithm."
HOMEPAGE="https://www.irif.fr/users/fm/index"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	if [[ ${CHOST} == *-darwin* ]] ; then
		sharedopt=-install_name "${ESYSROOT}"/usr/$(get_libdir)/libmodulardecomposition$(get_libname)
	else
		sharedopt=-Wl,-soname=libmodulardecomposition$(get_libname)
	fi
	$(tc-getCC) -o libmodulardecomposition$(get_libname) dm.c random.c \
		-fPIC -shared "${sharedopt}"
}

src_install(){
	dolib.so libmodulardecomposition$(get_libname)
	cp dm_english.h modular_decomposition.h
	doheader modular_decomposition.h
}
