# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic pax-utils

FETCH_P="${PN}_"$(ver_rs  3 '-')
MY_PV=$(ver_cut 1-3)
DESCRIPTION="A free C++ CAS (Computer Algebra System) library and its interfaces"
HOMEPAGE="http://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="http://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/${FETCH_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS="el en es fr pt"
IUSE="ao doc +ecm examples fltk gc +glpk static-libs"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
done

RDEPEND="dev-libs/gmp:=[cxx]
	sys-libs/readline:=
	fltk? ( >=x11-libs/fltk-1.1.9
		media-libs/libpng:= )
	ao? ( media-libs/libao )
	dev-libs/mpfr:=
	sci-libs/mpfi
	sci-libs/gsl:=
	>=sci-mathematics/pari-2.7:=
	dev-libs/ntl:=
	virtual/lapack
	virtual/blas
	net-misc/curl
	ecm? ( >=sci-mathematics/gmp-ecm-7.0.0 )
	glpk? ( sci-mathematics/glpk )
	gc? ( dev-libs/boehm-gc )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0.87-gsl_lapack.patch
	)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare(){
	if !(use fltk); then
		eapply "${FILESDIR}"/${PN}-1.2.2-test_with_nofltk.patch
	fi
	if has_version ">=sci-mathematics/pari-2.11.0" ; then
		eapply "${FILESDIR}"/pari_2_11.patch
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

	# Using libsamplerate is currently broken
	econf \
		--enable-gmpxx \
		--disable-samplerate \
		$(use_enable static-libs static) \
		$(use_enable fltk gui)  \
		$(use_enable fltk png)  \
		$(use_enable ao) \
		$(use_enable ecm) \
		$(use_enable glpk) \
		$(use_enable gc)

}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if use fltk; then
		if host-is-pax; then
			pax-mark -m "${ED}"/usr/bin/x*
		fi
	else
		rm -rf \
			"${ED}"/usr/bin/x* \
			"${ED}"/usr/share/application-registry \
			"${ED}"/usr/share/applications \
			"${ED}"/usr/share/icons
	fi

	if use !doc; then
		rm -R "${ED}"/usr/share/doc/giac* "${ED}"/usr/share/giac/doc/ || die
	else
		for lang in ${LANGS}; do
			if use l10n_$lang; then
				ln "${ED}"/usr/share/giac/doc/aide_cas "${ED}"/usr/share/giac/doc/"${lang}"/aide_cas || die
			else
				rm -rf "${ED}"/usr/share/giac/doc/"${lang}"
			fi
		done
	fi

	if use !examples; then
		rm -R "${ED}"/usr/share/giac/examples || die
	fi

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
