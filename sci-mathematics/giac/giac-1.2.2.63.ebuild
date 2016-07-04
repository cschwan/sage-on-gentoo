# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic pax-utils versionator

FETCH_P="${PN}_"$(replace_version_separator  3 '-')
MY_PV=$(get_version_component_range 1-3)
DESCRIPTION="A free C++ CAS (Computer Algebra System) library and its interfaces"
HOMEPAGE="http://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="http://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/${FETCH_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples gc"
# BUG: it is currently impossible to build without the gui

RDEPEND="dev-libs/gmp:=
	sys-libs/readline:=
	>=x11-libs/fltk-1.1.9
	media-libs/libao
	dev-libs/mpfr:=
	sci-libs/mpfi
	sci-libs/gsl:=
	>=sci-mathematics/pari-2.7:=
	dev-libs/ntl:=
	virtual/lapack
	gc? ( dev-libs/boehm-gc )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.2-cSolveorder-check.patch
	"${FILESDIR}"/${PN}-1.2.2-lapack.patch
	)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	append-cppflags -I$(fltk-config --includedir)
	append-lfs-flags
	append-libs $(fltk-config --ldflags | sed -e 's/\(-L\S*\)\s.*/\1/') || die
	# gmpxx interface is currently broken don't use it.
	econf \
		--enable-gui \
		--disable-gmpxx
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if host-is-pax; then
		pax-mark -m "${D}"/usr/bin/x*
	fi
	if use !doc; then
		rm -R "${D}"/usr/share/doc/giac* "${D}"/usr/share/giac/doc/ || die
	else
		for LANG in el en es fr pt; do
			if echo ${LINGUAS} | grep -v "$LANG" &> /dev/null; then
				rm -R "${D}"/usr/share/giac/doc/"$LANG"
			else
				ln "${D}"/usr/share/giac/doc/aide_cas "${D}"/usr/share/giac/doc/"$LANG"/aide_cas || die
			fi
		done
	fi
	if use !examples; then
		rm -R "${D}"/usr/share/giac/examples || die
	fi
}
