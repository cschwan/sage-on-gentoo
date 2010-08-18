# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="C implementation of the Double Description Method of Motzkin et al."
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc static-libs"

RESTRICT="mirror"

DEPEND=">=dev-libs/gmp-4.2.2"
RDEPEND="${DEPEND}"

# TODO: examples. cddlib installs programs named like test* which are maybe not
# used

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( ChangeLog README )
PATCHES=(
	"${FILESDIR}"/${PN}-094f-use-libtool.patch
	"${FILESDIR}"/${PN}-094f-add-cdd_both_reps-binary.patch
)

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf

	cp "${FILESDIR}"/cdd_both_reps.c "${S}"/src/ \
		|| die "failed to copy source file"
	ln -s "${S}"/src/cdd_both_reps.c "${S}"/src-gmp/cdd_both_reps.c \
		|| die "failed to make symbolic link to source file"
}

src_install() {
	if use doc ; then
		DOCS=( ${DOCS[@]} doc/cddlibman.pdf doc/cddlibman.ps )
	fi

	autotools-utils_src_install
}
