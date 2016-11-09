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
LANGS="el en es fr pt"
IUSE="ao doc examples fltk gc"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
done

RDEPEND="dev-libs/gmp:=[cxx]
	sys-libs/readline:=
	fltk? ( >=x11-libs/fltk-1.1.9 )
	ao? ( media-libs/libao )
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
	"${FILESDIR}"/${PN}-1.2.2-lapack.patch
	)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare(){
	if has_version "=sci-mathematics/pari-2.8*"; then
		eapply 	"${FILESDIR}"/${PN}-1.2.2.101-cSolveorder-check.patch
	fi
	if !(use fltk); then
		eapply "${FILESDIR}"/${PN}-1.2.2-test_with_nofltk.patch
	fi
	default

	eautoreconf
}

src_configure(){
	if use fltk; then
		append-cppflags -I$(fltk-config --includedir)
		append-lfs-flags
		append-libs $(fltk-config --ldflags | sed -e 's/\(-L\S*\)\s.*/\1/') || die
	fi

	econf \
		--enable-gmpxx \
		$(use_enable fltk gui)  \
		$(use_enable ao) \
		$(use_enable gc)

}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if use fltk; then
		if host-is-pax; then
			pax-mark -m "${D}"/usr/bin/x*
		fi
	else
		rm -rf \
			"${D}"/usr/bin/x* \
			"${D}"/usr/share/application-registry \
			"${D}"/usr/share/applications \
			"${D}"/usr/share/icons
	fi

	if use !doc; then
		rm -R "${D}"/usr/share/doc/giac* "${D}"/usr/share/giac/doc/ || die
	else
		for lang in ${LANGS}; do
			if use l10n_$lang; then
				ln "${D}"/usr/share/giac/doc/aide_cas "${D}"/usr/share/giac/doc/"${lang}"/aide_cas || die
			else
				rm -rf "${D}"/usr/share/giac/doc/"${lang}"
			fi
		done
	fi

	if use !examples; then
		rm -R "${D}"/usr/share/giac/examples || die
	fi
}
