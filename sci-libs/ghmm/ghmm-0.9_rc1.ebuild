# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils versionator

DESCRIPTION="The General Hidden Markov Model library"
HOMEPAGE="http://ghmm.sourceforge.net/"
MY_P=${PN}-$(replace_version_separator 2 '-')
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gsl lapack python"

RESTRICT="mirror"

# TODO: check dependencies
CDEPEND=">=dev-libs/libxml2-2.6.0
	sci-libs/gsl
	lapack? ( virtual/lapack )
	virtual/python"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	if use python ; then
		cd ghmmwrapper
		distutils_src_prepare
	fi
}

# TODO: configure is broken
src_configure() {
	econf \
		$(use_enable gsl) \
		$(use_enable lapack atlas) \
		--without-python \
		|| die "econf failed"
}

src_compile() {
	emake || die "emake failed"

	if use python ; then
		cd ghmmwrapper
		distutils_src_compile
	fi
}

# TODO: tests fail

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use python ; then
		cd ghmmwrapper
		distutils_src_install
	fi
}

pkg_postinst() {
	if use python ; then
		distutils_pkg_postinst
	fi
}

pkg_postrm() {
	if use python ; then
		distutils_pkg_postrm
	fi
}
