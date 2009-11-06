# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit eutils

DESCRIPTION="LINT is a C library for doing number theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

# TODO: flint uses its own version of zn_poly

src_compile() {
	export FLINT_GMP_INCLUDE_DIR=/usr/include
	export FLINT_GMP_LIB_DIR=/usr/lib
	export FLINT_LINK_OPTIONS="${LDFLAGS}"
	#export FLINT_NTL_INCLUDE_DIR=
	#export FLINT_NTL_LIB_DIR=

	source flint_env

	emake library || die "emake failed"
}

src_install() {
	dolib libflint.so
	insinto /usr/include/FLINT
	doins *.h
	dodoc CHANGES.txt todo.txt
}
