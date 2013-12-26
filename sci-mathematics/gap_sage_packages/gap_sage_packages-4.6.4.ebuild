# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit multilib

DESCRIPTION="A small collection of packages for GAP"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=">=sci-mathematics/gap-${PV}"
RDEPEND="${DEPEND}"

src_configure(){
	local gapdir="${EPREFIX}"/usr/$(get_libdir)/gap
	pushd grape
	./configure "${gapdir}"
	popd
	pushd guava-3.12
	./configure "${gapdir}"
	popd
}

src_compile(){
	pushd grape
	emake -j1
	popd
	pushd guava-3.12
	emake -j1
	popd
}

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg
	doins -r *
}
