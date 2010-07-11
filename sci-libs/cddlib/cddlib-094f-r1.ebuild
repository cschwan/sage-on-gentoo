# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils autotools

DESCRIPTION="C implementation of the Double Description Method of Motzkin et al."
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.2"
RDEPEND="${DEPEND}"

# TODO: examples. cddlib installs programs named like test* which are maybe not
# used

src_prepare() {
	epatch "${FILESDIR}"/${PN}-094f-use-libtool.patch
	epatch "${FILESDIR}"/${PN}-094f-add-cdd_both_reps-binary.patch

	cp "${FILESDIR}"/cdd_both_reps.c "${S}"/src/ \
		|| die "failed to copy source file"
	ln -s "${S}"/src/cdd_both_reps.c "${S}"/src-gmp/cdd_both_reps.c \
		|| die "failed to make symbolic link to source file"

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc ChangeLog README || die

	# install manuals
	if use doc ; then
		dodoc doc/cddlibman.pdf doc/cddlibman.ps || die
	fi
}
