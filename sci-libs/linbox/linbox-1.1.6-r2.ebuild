# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils

DESCRIPTION="LinBox is a C++ template library for linear algebra computation
over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc ntl sage"

# TODO: support examples ?

# disabling of commentator class breaks the tests
RESTRICT="mirror
	sage? ( test )"

CDEPEND="dev-libs/gmp[-nocxx]
	=sci-libs/givaro-3.2*
	virtual/cblas
	virtual/lapack
	expat? ( >=dev-libs/expat-1.95 )
	ntl? ( dev-libs/ntl )"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

src_prepare() {
	if use sage ; then
		# disable commentator; this is needed for sage
		epatch "${FILESDIR}"/${P}-disable-commentator.patch

		# fix problem with --as-needed
		epatch "${FILESDIR}"/${P}-fix-undefined-symbols.patch
	fi

	if use doc ; then
		epatch "${FILESDIR}"/${P}-fix-doc.patch
	fi

	epatch "${FILESDIR}"/${P}-fix-double-installation.patch

	# regenerate makefiles
	AT_M4DIR="${S}"/macros eautoreconf
}

src_configure() {
	# TODO: add other configure options
	# TODO: check use && use_with/use_enable statements
	# TODO: configure treats --disable-doc/-sage as --enable-doc/-sage
	# TODO: support maple, lidia, saclib ?
	econf \
		--enable-optimization \
		$(use doc && use_enable doc) \
		$(use_with ntl) \
		$(use sage && use_enable sage) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS TODO || die "dodoc failed"

	if use doc ; then
		dohtml -r doc/linbox-html/* || die "dohtml failed"
	fi
}
