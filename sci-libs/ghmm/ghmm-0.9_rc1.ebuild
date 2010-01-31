# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils flag-o-matic versionator

MY_P="${PN}-$(replace_version_separator 2 '-')"

DESCRIPTION="The General Hidden Markov Model library"
HOMEPAGE="http://ghmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl lapack python"

# tests are broken
RESTRICT="mirror test"

# depends on lapack from atlas because this lapack-version ships with clapack.h
# bug #302951: depend on lapack-atlas lower than 3.9.21
CDEPEND=">=dev-libs/libxml2-2.6.0
	>=sci-libs/gsl-1.4
	lapack? ( <=sci-libs/lapack-atlas-3.9.3 )
	python? ( virtual/python )"
DEPEND="${CDEPEND}
	>=dev-lang/swig-1.3.17
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	if use python ; then
		cd ghmmwrapper
		distutils_src_prepare
	fi
}

src_configure() {
	# do not build python, functions from distutils.eclass will do that
	econf \
		$(use_enable gsl) \
		$(use lapack && use_enable lapack atlas) \
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
