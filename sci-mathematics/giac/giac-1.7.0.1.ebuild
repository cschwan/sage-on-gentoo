# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

FETCH_P="${PN}_"$(ver_rs  3 '-')
MY_PV=$(ver_cut 1-3)
DESCRIPTION="A free C++ CAS (Computer Algebra System) library and its interfaces"
HOMEPAGE="https://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="https://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/${FETCH_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
# French documentation is not GPL, and is subject to a non commercial use license, so skipping it.
LANGS="el en es pt"
IUSE="ao doc +ecm examples gc +glpk gui static-libs test"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
done

# nauty and cliquer are automagical dependencies
RDEPEND="dev-libs/gmp:=[cxx]
	sys-libs/readline:=
	gui? ( >=x11-libs/fltk-1.1.9
		media-libs/libpng:= )
	ao? ( media-libs/libao )
	dev-libs/mpfr:=
	sci-libs/mpfi
	sci-libs/gsl:=
	>=sci-mathematics/pari-2.7:=[threads]
	dev-libs/ntl:=
	virtual/lapack
	virtual/blas
	net-misc/curl
	>=sci-mathematics/nauty-2.6.7
	sci-mathematics/cliquer
	ecm? ( >=sci-mathematics/gmp-ecm-7.0.0 )
	glpk? ( sci-mathematics/glpk )
	gc? ( dev-libs/boehm-gc )"

DEPEND="${RDEPEND}"

BDEPEND="dev-tex/hevea
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0.1-gsl_lapack.patch
	"${FILESDIR}"/pari_2_11.patch
	)

REQUIRED_USE="test? ( gui )"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare(){
	default

	eautoreconf
}

src_configure(){
	if use gui; then
		append-cppflags -I$(fltk-config --includedir)
		append-lfs-flags
		append-libs $(fltk-config --ldflags | sed -e 's/\(-L\S*\)\s.*/\1/') || die
	fi

	# giac doesn't like sdt=c++17 the default in gcc-11. Enforce std=c++14
	append-cxxflags -std=c++14

	# Using libsamplerate is currently broken
	# micropython is for specific use in an upstream project
	econf \
		--enable-gmpxx \
		--disable-samplerate \
		--disable-micropy \
		$(use_enable static-libs static) \
		$(use_enable gui)  \
		$(use_enable gui png)  \
		$(use_enable ao) \
		$(use_enable ecm) \
		$(use_enable glpk) \
		$(use_enable gc)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if !(use gui); then
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
		# Deleting French documentation for copyright reasons
		rm -rf "${ED}"/usr/share/giac/doc/fr
	fi

	if use !examples; then
		rm -R "${ED}"/usr/share/giac/examples || die
	fi

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
