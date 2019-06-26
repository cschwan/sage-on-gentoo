# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0/13"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc gc ntl static-libs"

RDEPEND="dev-libs/gmp:=
	dev-libs/mpfr:=
	gc? ( dev-libs/boehm-gc )
	ntl? ( dev-libs/ntl:= )"
DEPEND="${RDEPEND}
	doc? (
		app-text/texlive-core
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)"

PATCHES=(
	"${FILESDIR}"/flintxx-include.patch
	"${FILESDIR}"/${PN}-2.5.2-pie.patch
	"${FILESDIR}"/${PN}-2.5.2-utf8.patch
	)

src_configure() {
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-gmp="${EPREFIX}/usr" \
		--with-mpfr="${EPREFIX}/usr" \
		$(usex ntl "--with-ntl=${EPREFIX}/usr" "") \
		$(use_enable static-libs static) \
		$(usex gc "--with-gc=${EPREFIX}/usr" "") \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		|| die
}

src_compile() {
	emake verbose

	if use doc ; then
		emake -C doc/latex
	fi
}

src_test() {
	emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
	einstalldocs
	use doc && dodoc doc/latex/flint-manual.pdf
}
