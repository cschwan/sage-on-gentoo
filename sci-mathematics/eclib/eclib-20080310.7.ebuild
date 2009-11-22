# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION="4.2.1"
SAGE_PACKAGE="eclib-20080310.p7"

inherit eutils sage

# TODO: find description, homepage and license

DESCRIPTION=""
HOMEPAGE=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp
	dev-libs/ntl
	sci-mathematics/pari"
RDEPEND="${DEPEND}"

src_prepare() {
	# remove debug switch
	sed -i "s/ -g//g" "g0n/Makefile" "procs/Makefile" "qcurves/Makefile" \
		"qrank/Makefile" "Makefile" || die "sed failed"
}

src_compile() {
	# make fails with parallel build
	emake -j1 NTL_PREFIX="/usr" PARI_PREFIX="/usr" PICFLAG="-fPIC" all so \
		|| die "emake failed"
}

src_test() {
	# TODO: Tests fail because of missing libraries
	# TODO: This does not work
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/lib"

	emake check || die "emake check failed"
}

src_install() {
	dobin qrank/mwrank
	dobin qrank/ratpoint
	dobin qcurves/findinf
	dobin qcurves/tate
    dobin qcurves/conductor
    dobin qcurves/torsion
	dobin qcurves/twist
	dobin qcurves/allisog
	dobin qcurves/indep
    dobin procs/tconic
	dolib.so lib/*.so
	insinto /usr/include/eclib
	doins include/*.h
}
