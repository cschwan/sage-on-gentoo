# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic

DESCRIPTION="A library for polynomial arithmetic"
HOMEPAGE="http://www.cims.nyu.edu/~harvey/code/zn_poly/"
SRC_URI="http://www.cims.nyu.edu/~harvey/zn_poly/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpir"

RESTRICT="mirror"

# TODO: DEPENDs are only a guess
CDEPEND="mpir? ( sci-libs/mpir )
	!mpir? ( >=dev-libs/gmp-4.2.4 )"
DEPEND="${CDEPEND}
	dev-lang/python"
RDEPEND="${CDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-flint-hack.patch"
	epatch "${FILESDIR}/${P}-mpir.patch"
}

# TODO: --ntl-prefix= --use-flint --flint-prefix=

src_configure() {
	append-cflags -fPIC
	local mpirconfig=""
	if use mpir; then
		mpirconfig="--use-mpir"
	fi
	# this command actually calls a python script
	./configure \
		--prefix="${D}/usr" \
		--cflags="${CFLAGS}" \
		--ldflags="${LDFLAGS}" \
		--gmp-prefix=/usr \
		"${mpirconfig}" \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES
}
